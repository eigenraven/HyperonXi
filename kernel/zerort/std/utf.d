// Written in the D programming language.

/++
    Encode and decode UTF-8, UTF-16 and UTF-32 strings.

    UTF character support is restricted to
    $(D '\u0000' &lt;= character &lt;= '\U0010FFFF').

    See_Also:
        $(LINK2 http://en.wikipedia.org/wiki/Unicode, Wikipedia)<br>
        $(LINK http://www.cl.cam.ac.uk/~mgk25/unicode.html#utf-8)<br>
        $(LINK http://anubis.dkuug.dk/JTC1/SC2/WG2/docs/n1335)
    Macros:
        WIKI = Phobos/StdUtf

    Copyright: Copyright Digital Mars 2000 - 2012.
    License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   $(WEB digitalmars.com, Walter Bright) and Jonathan M Davis
    Source:    $(PHOBOSSRC std/_utf.d)
   +/
module std.utf;

import std.meta; // AliasSeq
import std.range.primitives;
import std.traits; // isSomeChar, isSomeString
import std.typecons; // Flag
//import std.exception;  // basicExceptionCtors

//debug=utf;           // uncomment to turn on debugging printf's

debug (utf) import core.stdc.stdio : printf;

private void invalidUTF(string msg, size_t idx = 0) pure nothrow @nogc @safe
{
}

/*
   Provide array of invalidly encoded UTF strings. Useful for testing.

   Params:
        Char = char, wchar, or dchar

   Returns:
        an array of invalidly encoded UTF strings
 */

package auto invalidUTFstrings(Char)() @safe pure @nogc nothrow 
		if (isSomeChar!Char)
{
	static if (is(Char == char))
	{
		enum x = 0xDC00; // invalid surrogate value
		enum y = 0x110000; // out of range

		static immutable string[8] result = [
			"\x80", // not a start byte
			"\xC0", // truncated
			"\xC0\xC0", // invalid continuation
			"\xF0\x82\x82\xAC", // overlong
			[0xE0 | (x >> 12), 0x80 | ((x >> 6) & 0x3F), 0x80 | (x & 0x3F)
		], [cast(char)(0xF0 | (y >> 18)), cast(char)(0x80 | ((y >> 12) & 0x3F)),
			cast(char)(0x80 | ((y >> 6) & 0x3F)), cast(char)(0x80 | (y & 0x3F))],
			[cast(char)(0xF8 | 3), // 5 byte encoding
			cast(char)(0x80 | 3), cast(char)(0x80 | 3), cast(char)(0x80 | 3),
			cast(char)(0x80 | 3),], [cast(char)(0xFC | 3), // 6 byte encoding
			cast(char)(0x80 | 3),
			cast(char)(0x80 | 3), cast(char)(0x80 | 3), cast(char)(0x80 | 3),
			cast(char)(0x80 | 3),],];

		return result[];
	}
	else static if (is(Char == wchar))
	{
		static immutable wstring[5] result = [
			[cast(wchar) 0xDC00,
		], [cast(wchar) 0xDFFF,], [
			cast(wchar) 0xDBFF, cast(wchar) 0xDBFF,
		], [cast(wchar) 0xDBFF, cast(wchar) 0xE000,], [cast(wchar) 0xD800,],];

		return result[];
	}
	else static if (is(Char == dchar))
	{
		static immutable dstring[3] result = [
			[cast(dchar) 0x110000
		], [cast(dchar) 0x00D800], [cast(dchar) 0x00DFFF],];

		return result;
	}
	else
		static assert(0);
}

/++
    Check whether the given Unicode code point is valid.

    Params:
        c = code point to check

    Returns:
        $(D true) iff $(D c) is a valid Unicode code point

    Note:
    $(D '\uFFFE') and $(D '\uFFFF') are considered valid by $(D isValidDchar),
    as they are permitted for internal use by an application, but they are
    not allowed for interchange by the Unicode standard.
  +/
bool isValidDchar(dchar c) pure nothrow @safe @nogc
{
	/* Note: FFFE and FFFF are specifically permitted by the
     * Unicode standard for application internal use, but are not
     * allowed for interchange.
     * (thanks to Arcane Jill)
     */

	return c < 0xD800 || (c > 0xDFFF && c <= 0x10FFFF /*&& c != 0xFFFE && c != 0xFFFF*/ );
}

/++
    Calculate the length of the UTF sequence starting at $(D index)
    in $(D str).

    Params:
        str = input range of UTF code units. Must be random access if
        $(D index) is passed
        index = starting index of UTF sequence (default: $(D 0))

    Returns:
        The number of code units in the UTF sequence. For UTF-8, this is a
        value between 1 and 4 (as per $(WEB tools.ietf.org/html/rfc3629#section-3, RFC 3629$(COMMA) section 3)).
        For UTF-16, it is either 1 or 2. For UTF-32, it is always 1.

    Throws:
        May throw a $(D UTFException) if $(D str[index]) is not the start of a
        valid UTF sequence.

    Note:
        $(D stride) will only analyze the first $(D str[index]) element. It
        will not fully verify the validity of the UTF sequence, nor even verify
        the presence of the sequence: it will not actually guarantee that
        $(D index + stride(str, index) <= str.length).
  +/
uint stride(S)(auto ref S str, size_t index)
		if (is(S : const char[]) || (isRandomAccessRange!S && is(Unqual!(ElementType!S) == char)))
{
	static if (is(typeof(str.length) : ulong))
		assert(index < str.length, "Past the end of the UTF-8 sequence");
	immutable c = str[index];

	if (c < 0x80)
		return 1;
	else
		return strideImpl(c, index);
}

/// Ditto
uint stride(S)(auto ref S str)
		if (is(S : const char[]) || (isInputRange!S && is(Unqual!(ElementType!S) == char)))
{
	static if (is(S : const char[]))
		immutable c = str[0];
	else
		immutable c = str.front;

	if (c < 0x80)
		return 1;
	else
		return strideImpl(c, 0);
}

private uint strideImpl(char c, size_t index) @trusted pure
in
{
	assert(c & 0x80);
}
body
{
	import core.bitop : bsr;

	immutable msbs = 7 - bsr(~c);
	if (!~c || msbs < 2 || msbs > 4)
		invalidUTF("Invalid UTF-8 sequence", index);
	return msbs;
}

/// Ditto
uint stride(S)(auto ref S str, size_t index)
		if (is(S : const wchar[]) || (isRandomAccessRange!S && is(Unqual!(ElementType!S) == wchar)))
{
	static if (is(typeof(str.length) : ulong))
		assert(index < str.length, "Past the end of the UTF-16 sequence");
	immutable uint u = str[index];
	return 1 + (u >= 0xD800 && u <= 0xDBFF);
}

/// Ditto
uint stride(S)(auto ref S str) @safe pure if (is(S : const wchar[]))
{
	return stride(str, 0);
}

/// Ditto
uint stride(S)(auto ref S str)
		if (isInputRange!S && is(Unqual!(ElementType!S) == wchar))
{
	assert(!str.empty, "UTF-16 sequence is empty");
	immutable uint u = str.front;
	return 1 + (u >= 0xD800 && u <= 0xDBFF);
}

/// Ditto
uint stride(S)(auto ref S str, size_t index = 0)
		if (is(S : const dchar[]) || (isInputRange!S
			&& is(Unqual!(ElementEncodingType!S) == dchar)))
{
	static if (is(typeof(str.length) : ulong))
		assert(index < str.length, "Past the end of the UTF-32 sequence");
	else
		assert(!str.empty, "UTF-32 sequence is empty.");
	return 1;
}

/++
    Calculate the length of the UTF sequence ending one code unit before
    $(D index) in $(D str).

    Params:
        str = bidirectional range of UTF code units. Must be random access if
        $(D index) is passed
        index = index one past end of UTF sequence (default: $(D str.length))

    Returns:
        The number of code units in the UTF sequence. For UTF-8, this is a
        value between 1 and 4 (as per $(WEB tools.ietf.org/html/rfc3629#section-3, RFC 3629$(COMMA) section 3)).
        For UTF-16, it is either 1 or 2. For UTF-32, it is always 1.

    Throws:
        May throw a $(D UTFException) if $(D str[index]) is not one past the
        end of a valid UTF sequence.

    Note:
        $(D strideBack) will only analyze the element at $(D str[index - 1])
        element. It will not fully verify the validity of the UTF sequence, nor
        even verify the presence of the sequence: it will not actually
        guarantee that $(D strideBack(str, index) <= index).
  +/
uint strideBack(S)(auto ref S str, size_t index)
		if (is(S : const char[]) || (isRandomAccessRange!S && is(Unqual!(ElementType!S) == char)))
{
	static if (is(typeof(str.length) : ulong))
		assert(index <= str.length, "Past the end of the UTF-8 sequence");
	assert(index > 0, "Not the end of the UTF-8 sequence");

	if ((str[index - 1] & 0b1100_0000) != 0b1000_0000)
		return 1;

	if (index >= 4) //single verification for most common case
	{
		foreach (i; AliasSeq!(2, 3, 4))
		{
			if ((str[index - i] & 0b1100_0000) != 0b1000_0000)
				return i;
		}
	}
	else
	{
		foreach (i; AliasSeq!(2, 3))
		{
			if (index >= i && (str[index - i] & 0b1100_0000) != 0b1000_0000)
				return i;
		}
	}
	invalidUTF("Not the end of the UTF sequence", index);
}

/// Ditto
uint strideBack(S)(auto ref S str)
		if (is(S : const char[]) || (isRandomAccessRange!S && hasLength!S
			&& is(Unqual!(ElementType!S) == char)))
{
	return strideBack(str, str.length);
}

/// Ditto
uint strideBack(S)(auto ref S str)
		if (isBidirectionalRange!S && is(Unqual!(ElementType!S) == char)
			&& !isRandomAccessRange!S)
{
	assert(!str.empty, "Past the end of the UTF-8 sequence");
	auto temp = str.save;
	foreach (i; AliasSeq!(1, 2, 3, 4))
	{
		if ((temp.back & 0b1100_0000) != 0b1000_0000)
			return i;
		temp.popBack();
		if (temp.empty)
			break;
	}
	invalidUTF("The last code unit is not the end of the UTF-8 sequence");
}

//UTF-16 is self synchronizing: The length of strideBack can be found from
//the value of a single wchar
/// Ditto
uint strideBack(S)(auto ref S str, size_t index)
		if (is(S : const wchar[]) || (isRandomAccessRange!S && is(Unqual!(ElementType!S) == wchar)))
{
	static if (is(typeof(str.length) : ulong))
		assert(index <= str.length, "Past the end of the UTF-16 sequence");
	assert(index > 0, "Not the end of a UTF-16 sequence");

	immutable c2 = str[index - 1];
	return 1 + (0xDC00 <= c2 && c2 < 0xE000);
}

/// Ditto
uint strideBack(S)(auto ref S str)
		if (is(S : const wchar[]) || (isBidirectionalRange!S
			&& is(Unqual!(ElementType!S) == wchar)))
{
	assert(!str.empty, "UTF-16 sequence is empty");

	static if (is(S : const(wchar)[]))
		immutable c2 = str[$ - 1];
	else
		immutable c2 = str.back;

	return 1 + (0xDC00 <= c2 && c2 <= 0xE000);
}

/// Ditto
uint strideBack(S)(auto ref S str, size_t index)
		if (isRandomAccessRange!S && is(Unqual!(ElementEncodingType!S) == dchar))
{
	static if (is(typeof(str.length) : ulong))
		assert(index <= str.length, "Past the end of the UTF-32 sequence");
	assert(index > 0, "Not the end of the UTF-32 sequence");
	return 1;
}

/// Ditto
uint strideBack(S)(auto ref S str)
		if (isBidirectionalRange!S && is(Unqual!(ElementEncodingType!S) == dchar))
{
	assert(!str.empty, "Empty UTF-32 sequence");
	return 1;
}

/++
    Given $(D index) into $(D str) and assuming that $(D index) is at the start
    of a UTF sequence, $(D toUCSindex) determines the number of UCS characters
    up to $(D index). So, $(D index) is the index of a code unit at the
    beginning of a code point, and the return value is how many code points into
    the string that that code point is.
  +/
size_t toUCSindex(C)(const(C)[] str, size_t index) @safe pure if (isSomeChar!C)
{
	static if (is(Unqual!C == dchar))
		return index;
	else
	{
		size_t n = 0;
		size_t j = 0;

		for (; j < index; ++n)
			j += stride(str, j);

		if (j > index)
		{
			static if (is(Unqual!C == char))
				invalidUTF("Invalid UTF-8 sequence", index);
			else
				invalidUTF("Invalid UTF-16 sequence", index);
		}

		return n;
	}
}

///
unittest
{
	assert(toUCSindex(`hello world`, 7) == 7);
	assert(toUCSindex(`hello world`w, 7) == 7);
	assert(toUCSindex(`hello world`d, 7) == 7);

	assert(toUCSindex(`Ma Chérie`, 7) == 6);
	assert(toUCSindex(`Ma Chérie`w, 7) == 7);
	assert(toUCSindex(`Ma Chérie`d, 7) == 7);

	assert(toUCSindex(`さいごの果実 / ミツバチと科学者`, 9) == 3);
	assert(toUCSindex(`さいごの果実 / ミツバチと科学者`w, 9) == 9);
	assert(toUCSindex(`さいごの果実 / ミツバチと科学者`d, 9) == 9);
}

/++
    Given a UCS index $(D n) into $(D str), returns the UTF index.
    So, $(D n) is how many code points into the string the code point is, and
    the array index of the code unit is returned.
  +/
size_t toUTFindex(C)(const(C)[] str, size_t n) @safe pure if (isSomeChar!C)
{
	static if (is(Unqual!C == dchar))
	{
		return n;
	}
	else
	{
		size_t i;
		while (n--)
		{
			i += stride(str, i);
		}
		return i;
	}
}

///
unittest
{
	assert(toUTFindex(`hello world`, 7) == 7);
	assert(toUTFindex(`hello world`w, 7) == 7);
	assert(toUTFindex(`hello world`d, 7) == 7);

	assert(toUTFindex(`Ma Chérie`, 6) == 7);
	assert(toUTFindex(`Ma Chérie`w, 7) == 7);
	assert(toUTFindex(`Ma Chérie`d, 7) == 7);

	assert(toUTFindex(`さいごの果実 / ミツバチと科学者`, 3) == 9);
	assert(toUTFindex(`さいごの果実 / ミツバチと科学者`w, 9) == 9);
	assert(toUTFindex(`さいごの果実 / ミツバチと科学者`d, 9) == 9);
}

/* =================== Decode ======================= */

/// Whether or not to replace invalid UTF with $(LREF replacementDchar)
alias UseReplacementDchar = Flag!"useReplacementDchar";

/++
    Decodes and returns the code point starting at $(D str[index]). $(D index)
    is advanced to one past the decoded code point. If the code point is not
    well-formed, then a $(D UTFException) is thrown and $(D index) remains
    unchanged.

    decode will only work with strings and random access ranges of code units
    with length and slicing, whereas $(LREF decodeFront) will work with any
    input range of code units.

    Params:
        useReplacementDchar = if invalid UTF, return replacementDchar rather than throwing
        str = input string or indexable Range
        index = starting index into s[]; incremented by number of code units processed

    Returns:
        decoded character

    Throws:
        $(LREF UTFException) if $(D str[index]) is not the start of a valid UTF
        sequence and useReplacementDchar is UseReplacementDchar.no
  +/
dchar decode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		auto ref S str, ref size_t index)
		if (!isSomeString!S && isRandomAccessRange!S && hasSlicing!S
			&& hasLength!S && isSomeChar!(ElementType!S))
in
{
	assert(index < str.length, "Attempted to decode past the end of a string");
}
out (result)
{
	assert(isValidDchar(result));
}
body
{
	if (str[index] < codeUnitLimit!S)
		return str[index++];
	else
		return decodeImpl!(true, useReplacementDchar)(str, index);
}

dchar decode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		auto ref S str, ref size_t index) @trusted pure if (isSomeString!S)
in
{
	assert(index < str.length, "Attempted to decode past the end of a string");
}
out (result)
{
	assert(isValidDchar(result));
}
body
{
	if (str[index] < codeUnitLimit!S)
		return str[index++];
	else
		return decodeImpl!(true, useReplacementDchar)(str, index);
}

/++
    $(D decodeFront) is a variant of $(LREF decode) which specifically decodes
    the first code point. Unlike $(LREF decode), $(D decodeFront) accepts any
    input range of code units (rather than just a string or random access
    range). It also takes the range by $(D ref) and pops off the elements as it
    decodes them. If $(D numCodeUnits) is passed in, it gets set to the number
    of code units which were in the code point which was decoded.

    Params:
        useReplacementDchar = if invalid UTF, return replacementDchar rather than throwing
        str = input string or indexable Range
        numCodeUnits = set to number of code units processed

    Returns:
        decoded character

    Throws:
        $(LREF UTFException) if $(D str.front) is not the start of a valid UTF
        sequence. If an exception is thrown, then there is no guarantee as to
        the number of code units which were popped off, as it depends on the
        type of range being used and how many code units had to be popped off
        before the code point was determined to be invalid.
  +/
dchar decodeFront(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		ref S str, out size_t numCodeUnits)
		if (!isSomeString!S && isInputRange!S && isSomeChar!(ElementType!S))
in
{
	assert(!str.empty);
}
out (result)
{
	assert(isValidDchar(result));
}
body
{
	immutable fst = str.front;

	if (fst < codeUnitLimit!S)
	{
		str.popFront();
		numCodeUnits = 1;
		return fst;
	}
	else
	{
		//@@@BUG@@@ 14447 forces canIndex to be done outside of decodeImpl, which
		//is undesirable, since not all overloads of decodeImpl need it. So, it
		//should be moved back into decodeImpl once bug# 8521 has been fixed.
		enum canIndex = isRandomAccessRange!S && hasSlicing!S && hasLength!S;
		immutable retval = decodeImpl!(canIndex, useReplacementDchar)(str, numCodeUnits);

		// The other range types were already popped by decodeImpl.
		static if (isRandomAccessRange!S && hasSlicing!S && hasLength!S)
			str = str[numCodeUnits .. str.length];

		return retval;
	}
}

dchar decodeFront(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		ref S str, out size_t numCodeUnits) @trusted pure if (isSomeString!S)
in
{
	assert(!str.empty);
}
out (result)
{
	assert(isValidDchar(result));
}
body
{
	if (str[0] < codeUnitLimit!S)
	{
		numCodeUnits = 1;
		immutable retval = str[0];
		str = str[1 .. $];
		return retval;
	}
	else
	{
		immutable retval = decodeImpl!(true, useReplacementDchar)(str, numCodeUnits);
		str = str[numCodeUnits .. $];
		return retval;
	}
}

/++ Ditto +/
dchar decodeFront(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(ref S str)
		if (isInputRange!S && isSomeChar!(ElementType!S))
{
	size_t numCodeUnits;
	return decodeFront!useReplacementDchar(str, numCodeUnits);
}

// Gives the maximum value that a code unit for the given range type can hold.
package template codeUnitLimit(S) if (isSomeChar!(ElementEncodingType!S))
{
	static if (is(Unqual!(ElementEncodingType!S) == char))
		enum char codeUnitLimit = 0x80;
	else static if (is(Unqual!(ElementEncodingType!S) == wchar))
		enum wchar codeUnitLimit = 0xD800;
	else
		enum dchar codeUnitLimit = 0xD800;
}

/*
 * For strings, this function does its own bounds checking to give a
 * more useful error message when attempting to decode past the end of a string.
 * Subsequently it uses a pointer instead of an array to avoid
 * redundant bounds checking.
 *
 * The three overloads of this operate on chars, wchars, and dchars.
 *
 * Params:
 *      canIndex = if S is indexable
 *      useReplacementDchar = if invalid UTF, return replacementDchar rather than throwing
 *      str = input string or Range
 *      index = starting index into s[]; incremented by number of code units processed
 *
 * Returns:
 *      decoded character
 */
private dchar decodeImpl(bool canIndex,
		UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		auto ref S str, ref size_t index)
		if (is(S : const char[]) || (isInputRange!S && is(Unqual!(ElementEncodingType!S) == char)))
{
	/* The following encodings are valid, except for the 5 and 6 byte
     * combinations:
     *  0xxxxxxx
     *  110xxxxx 10xxxxxx
     *  1110xxxx 10xxxxxx 10xxxxxx
     *  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
     *  111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
     *  1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
     */

	/* Dchar bitmask for different numbers of UTF-8 code units.
     */
	alias bitMask = AliasSeq!((1 << 7) - 1, (1 << 11) - 1, (1 << 16) - 1, (1 << 21) - 1);

	static if (is(S : const char[]))
		auto pstr = str.ptr + index;
	else static if (isRandomAccessRange!S && hasSlicing!S && hasLength!S)
		auto pstr = str[index .. str.length];
	else
		alias pstr = str;

	//@@@BUG@@@ 14447 forces this to be done outside of decodeImpl
	//enum canIndex = is(S : const char[]) || (isRandomAccessRange!S && hasSlicing!S && hasLength!S);

	static if (canIndex)
	{
		immutable length = str.length - index;
		ubyte fst = pstr[0];
	}
	else
	{
		ubyte fst = pstr.front;
		pstr.popFront();
	}

	static if (!useReplacementDchar)
	{
		static if (canIndex)
		{
			static void exception(S)(S str, string msg)
			{
				uint[4] sequence = void;
				size_t i;

				do
				{
					sequence[i] = str[i];
				}
				while (++i < str.length && i < 4 && (str[i] & 0xC0) == 0x80);

				.invalidUTF(msg, i);
			}
		}

		void invalidUTF()
		{
			static if (canIndex)
				.invalidUTF("Invalid UTF-8 sequence");
			else
			{
				//We can't include the invalid sequence with input strings without
				//saving each of the code units along the way, and we can't do it with
				//forward ranges without saving the entire range. Both would incur a
				//cost for the decoding of every character just to provide a better
				//error message for the (hopefully) rare case when an invalid UTF-8
				//sequence is encountered, so we don't bother trying to include the
				//invalid sequence here, unlike with strings and sliceable ranges.
				.invalidUTF("Invalid UTF-8 sequence");
			}
		}

		void outOfBounds()
		{
			.invalidUTF("Attempted to decode past the end of a string");
		}
	}

	if ((fst & 0b1100_0000) != 0b1100_0000)
	{
		static if (useReplacementDchar)
		{
			++index; // always consume bad input to avoid infinite loops
			return replacementDchar;
		}
		else
			invalidUTF(); // starter must have at least 2 first bits set
	}
	ubyte tmp = void;
	dchar d = fst; // upper control bits are masked out later
	fst <<= 1;

	foreach (i; AliasSeq!(1, 2, 3))
	{

		static if (canIndex)
		{
			if (i == length)
			{
				static if (useReplacementDchar)
				{
					index += i;
					return replacementDchar;
				}
				else
					outOfBounds();
			}
		}
		else
		{
			if (pstr.empty)
			{
				static if (useReplacementDchar)
				{
					index += i;
					return replacementDchar;
				}
				else
					outOfBounds();
			}
		}

		static if (canIndex)
			tmp = pstr[i];
		else
		{
			tmp = pstr.front;
			pstr.popFront();
		}

		if ((tmp & 0xC0) != 0x80)
		{
			static if (useReplacementDchar)
			{
				index += i + 1;
				return replacementDchar;
			}
			else
				invalidUTF();
		}

		d = (d << 6) | (tmp & 0x3F);
		fst <<= 1;

		if (!(fst & 0x80)) // no more bytes
		{
			d &= bitMask[i]; // mask out control bits

			// overlong, could have been encoded with i bytes
			if ((d & ~bitMask[i - 1]) == 0)
			{
				static if (useReplacementDchar)
				{
					index += i + 1;
					return replacementDchar;
				}
				else
					invalidUTF();
			}

			// check for surrogates only needed for 3 bytes
			static if (i == 2)
			{
				if (!isValidDchar(d))
				{
					static if (useReplacementDchar)
					{
						index += i + 1;
						return replacementDchar;
					}
					else
						invalidUTF();
				}
			}

			index += i + 1;
			static if (i == 3)
			{
				if (d > dchar.max)
				{
					static if (useReplacementDchar)
						d = replacementDchar;
					else
						invalidUTF();
				}
			}
			return d;
		}
	}

	static if (useReplacementDchar)
	{
		index += 4; // read 4 chars by now
		return replacementDchar;
	}
	else
		invalidUTF();
	assert(0);
}

@safe pure @nogc nothrow unittest
{
	// Add tests for useReplacemendDchar==yes path

	static struct R
	{
	@safe pure @nogc nothrow:
		this(string s)
		{
			this.s = s;
		}

		@property bool empty()
		{
			return idx == s.length;
		}

		@property char front()
		{
			return s[idx];
		}

		void popFront()
		{
			++idx;
		}

		size_t idx;
		string s;
	}

	foreach (s; invalidUTFstrings!char())
	{
		auto r = R(s);
		size_t index;
		dchar dc = decodeImpl!(false, Flag!"useReplacementDchar".yes)(r, index);
		assert(dc == replacementDchar);
		assert(1 <= index && index <= s.length);
	}
}

private dchar decodeImpl(bool canIndex,
		UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		auto ref S str, ref size_t index)
		if (is(S : const wchar[]) || (isInputRange!S
			&& is(Unqual!(ElementEncodingType!S) == wchar)))
{
	static if (is(S : const wchar[]))
		auto pstr = str.ptr + index;
	else static if (isRandomAccessRange!S && hasSlicing!S && hasLength!S)
		auto pstr = str[index .. str.length];
	else
		alias pstr = str;

	//@@@BUG@@@ 14447 forces this to be done outside of decodeImpl
	//enum canIndex = is(S : const wchar[]) || (isRandomAccessRange!S && hasSlicing!S && hasLength!S);

	static if (canIndex)
	{
		immutable length = str.length - index;
		uint u = pstr[0];
	}
	else
	{
		uint u = pstr.front;
		pstr.popFront();
	}

	static if (!useReplacementDchar)
	{
		UTFException exception(string msg)
		{
			.invalidUTF(msg);
		}
	}

	string msg;

	// The < case must be taken care of before decodeImpl is called.
	assert(u >= 0xD800);

	if (u <= 0xDBFF)
	{
		static if (canIndex)
			immutable onlyOneCodeUnit = length == 1;
		else
			immutable onlyOneCodeUnit = pstr.empty;

		if (onlyOneCodeUnit)
		{
			static if (useReplacementDchar)
			{
				++index;
				return replacementDchar;
			}
			else
				throw exception("surrogate UTF-16 high value past end of string");
		}

		static if (canIndex)
			immutable uint u2 = pstr[1];
		else
		{
			immutable uint u2 = pstr.front;
			pstr.popFront();
		}

		if (u2 < 0xDC00 || u2 > 0xDFFF)
		{
			static if (useReplacementDchar)
				u = replacementDchar;
			else
				throw exception("surrogate UTF-16 low value out of range");
		}
		else
			u = ((u - 0xD7C0) << 10) + (u2 - 0xDC00);
		++index;
	}
	else if (u >= 0xDC00 && u <= 0xDFFF)
	{
		static if (useReplacementDchar)
			u = replacementDchar;
		else
			throw exception("unpaired surrogate UTF-16 value");
	}
	++index;

	// Note: u+FFFE and u+FFFF are specifically permitted by the
	// Unicode standard for application internal use (see isValidDchar)

	return cast(dchar) u;
}

pure @nogc nothrow unittest
{
	// Add tests for useReplacemendDchar==true path

	static struct R
	{
	@safe pure @nogc nothrow:
		this(wstring s)
		{
			this.s = s;
		}

		@property bool empty()
		{
			return idx == s.length;
		}

		@property wchar front()
		{
			return s[idx];
		}

		void popFront()
		{
			++idx;
		}

		size_t idx;
		wstring s;
	}

	foreach (s; invalidUTFstrings!wchar())
	{
		auto r = R(s);
		size_t index;
		dchar dc = decodeImpl!(false, Flag!"useReplacementDchar".yes)(r, index);
		assert(dc == replacementDchar);
		assert(1 <= index && index <= s.length);
	}
}

private dchar decodeImpl(bool canIndex,
		UseReplacementDchar useReplacementDchar = UseReplacementDchar.no, S)(
		auto ref S str, ref size_t index)
		if (is(S : const dchar[]) || (isInputRange!S
			&& is(Unqual!(ElementEncodingType!S) == dchar)))
{
	static if (is(S : const dchar[]))
		auto pstr = str.ptr;
	else
		alias pstr = str;

	static if (is(S : const dchar[]) || isRandomAccessRange!S)
	{
		dchar dc = pstr[index];
		if (!isValidDchar(dc))
		{
			static if (useReplacementDchar)
				dc = replacementDchar;
			else
				invalidUTF("Invalid UTF-32 value");
		}
		++index;
		return dc;
	}
	else
	{
		dchar dc = pstr.front;
		if (!isValidDchar(dc))
		{
			static if (useReplacementDchar)
				dc = replacementDchar;
			else
				invalidUTF("Invalid UTF-32 value");
		}
		++index;
		pstr.popFront();
		return dc;
	}
}

pure @nogc nothrow unittest
{
	// Add tests for useReplacemendDchar==true path

	static struct R
	{
	@safe pure @nogc nothrow:
		this(dstring s)
		{
			this.s = s;
		}

		@property bool empty()
		{
			return idx == s.length;
		}

		@property dchar front()
		{
			return s[idx];
		}

		void popFront()
		{
			++idx;
		}

		size_t idx;
		dstring s;
	}

	foreach (s; invalidUTFstrings!dchar())
	{
		auto r = R(s);
		size_t index;
		dchar dc = decodeImpl!(false, Flag!"useReplacementDchar".yes)(r, index);
		assert(dc == replacementDchar);
		assert(1 <= index && index <= s.length);
	}
}

/* =================== Encode ======================= */

private dchar _utfException(UseReplacementDchar useReplacementDchar)(string msg, dchar c)
{
	static if (useReplacementDchar)
		return replacementDchar;
	else
		invalidUTF(msg);
}

/++
    Encodes $(D c) into the static array, $(D buf), and returns the actual
    length of the encoded character (a number between $(D 1) and $(D 4) for
    $(D char[4]) buffers and a number between $(D 1) and $(D 2) for
    $(D wchar[2]) buffers).

    Throws:
        $(D UTFException) if $(D c) is not a valid UTF code point.
  +/
size_t encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(
		ref char[4] buf, dchar c) @safe pure
{
	if (c <= 0x7F)
	{
		assert(isValidDchar(c));
		buf[0] = cast(char) c;
		return 1;
	}
	if (c <= 0x7FF)
	{
		assert(isValidDchar(c));
		buf[0] = cast(char)(0xC0 | (c >> 6));
		buf[1] = cast(char)(0x80 | (c & 0x3F));
		return 2;
	}
	if (c <= 0xFFFF)
	{
		if (0xD800 <= c && c <= 0xDFFF)
			c = _utfException!useReplacementDchar("Encoding a surrogate code point in UTF-8", c);

		assert(isValidDchar(c));
	L3:
		buf[0] = cast(char)(0xE0 | (c >> 12));
		buf[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
		buf[2] = cast(char)(0x80 | (c & 0x3F));
		return 3;
	}
	if (c <= 0x10FFFF)
	{
		assert(isValidDchar(c));
		buf[0] = cast(char)(0xF0 | (c >> 18));
		buf[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
		buf[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
		buf[3] = cast(char)(0x80 | (c & 0x3F));
		return 4;
	}

	assert(!isValidDchar(c));
	c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-8", c);
	goto L3;
}

/// Ditto
size_t encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(
		ref wchar[2] buf, dchar c) @safe pure
{
	if (c <= 0xFFFF)
	{
		if (0xD800 <= c && c <= 0xDFFF)
			c = _utfException!useReplacementDchar(
					"Encoding an isolated surrogate code point in UTF-16", c);

		assert(isValidDchar(c));
	L1:
		buf[0] = cast(wchar) c;
		return 1;
	}
	if (c <= 0x10FFFF)
	{
		assert(isValidDchar(c));
		buf[0] = cast(wchar)((((c - 0x10000) >> 10) & 0x3FF) + 0xD800);
		buf[1] = cast(wchar)(((c - 0x10000) & 0x3FF) + 0xDC00);
		return 2;
	}

	c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-16", c);
	goto L1;
}

/// Ditto
size_t encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(
		ref dchar[1] buf, dchar c) @safe pure
{
	if ((0xD800 <= c && c <= 0xDFFF) || 0x10FFFF < c)
		c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-32", c);
	else
		assert(isValidDchar(c));
	buf[0] = c;
	return 1;
}

/++
    Encodes $(D c) in $(D str)'s encoding and appends it to $(D str).

    Throws:
        $(D UTFException) if $(D c) is not a valid UTF code point.
  +/
void encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(ref char[] str,
		dchar c) @safe pure
{
	char[] r = str;

	if (c <= 0x7F)
	{
		assert(isValidDchar(c));
		r ~= cast(char) c;
	}
	else
	{
		char[4] buf;
		uint L;

		if (c <= 0x7FF)
		{
			assert(isValidDchar(c));
			buf[0] = cast(char)(0xC0 | (c >> 6));
			buf[1] = cast(char)(0x80 | (c & 0x3F));
			L = 2;
		}
		else if (c <= 0xFFFF)
		{
			if (0xD800 <= c && c <= 0xDFFF)
				c = _utfException!useReplacementDchar("Encoding a surrogate code point in UTF-8", c);

			assert(isValidDchar(c));
		L3:
			buf[0] = cast(char)(0xE0 | (c >> 12));
			buf[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
			buf[2] = cast(char)(0x80 | (c & 0x3F));
			L = 3;
		}
		else if (c <= 0x10FFFF)
		{
			assert(isValidDchar(c));
			buf[0] = cast(char)(0xF0 | (c >> 18));
			buf[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
			buf[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
			buf[3] = cast(char)(0x80 | (c & 0x3F));
			L = 4;
		}
		else
		{
			assert(!isValidDchar(c));
			c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-8", c);
			goto L3;
		}
		r ~= buf[0 .. L];
	}
	str = r;
}

/// ditto
void encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(ref wchar[] str,
		dchar c) @safe pure
{
	wchar[] r = str;

	if (c <= 0xFFFF)
	{
		if (0xD800 <= c && c <= 0xDFFF)
			c = _utfException!useReplacementDchar(
					"Encoding an isolated surrogate code point in UTF-16", c);

		assert(isValidDchar(c));
	L1:
		r ~= cast(wchar) c;
	}
	else if (c <= 0x10FFFF)
	{
		wchar[2] buf;

		assert(isValidDchar(c));
		buf[0] = cast(wchar)((((c - 0x10000) >> 10) & 0x3FF) + 0xD800);
		buf[1] = cast(wchar)(((c - 0x10000) & 0x3FF) + 0xDC00);
		r ~= buf;
	}
	else
	{
		assert(!isValidDchar(c));
		c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-16", c);
		goto L1;
	}

	str = r;
}

/// ditto
void encode(UseReplacementDchar useReplacementDchar = UseReplacementDchar.no)(ref dchar[] str,
		dchar c) @safe pure
{
	if ((0xD800 <= c && c <= 0xDFFF) || 0x10FFFF < c)
		c = _utfException!useReplacementDchar("Encoding an invalid code point in UTF-32", c);
	else
		assert(isValidDchar(c));
	str ~= c;
}

/++
    Returns the number of code units that are required to encode the code point
    $(D c) when $(D C) is the character type used to encode it.
  +/
ubyte codeLength(C)(dchar c) @safe pure nothrow @nogc if (isSomeChar!C)
{
	static if (C.sizeof == 1)
	{
		if (c <= 0x7F)
			return 1;
		if (c <= 0x7FF)
			return 2;
		if (c <= 0xFFFF)
			return 3;
		if (c <= 0x10FFFF)
			return 4;
		assert(false);
	}
	else static if (C.sizeof == 2)
	{
		return c <= 0xFFFF ? 1 : 2;
	}
	else
	{
		static assert(C.sizeof == 4);
		return 1;
	}
}

///
pure nothrow @nogc unittest
{
	assert(codeLength!char('a') == 1);
	assert(codeLength!wchar('a') == 1);
	assert(codeLength!dchar('a') == 1);

	assert(codeLength!char('\U0010FFFF') == 4);
	assert(codeLength!wchar('\U0010FFFF') == 2);
	assert(codeLength!dchar('\U0010FFFF') == 1);
}

/++
    Returns the number of code units that are required to encode $(D str)
    in a string whose character type is $(D C). This is particularly useful
    when slicing one string with the length of another and the two string
    types use different character types.
  +/
size_t codeLength(C, InputRange)(InputRange input)
		if (isInputRange!InputRange && is(ElementType!InputRange : dchar))
{
	alias EncType = Unqual!(ElementEncodingType!InputRange);
	static if (isSomeString!InputRange && is(EncType == C) && is(typeof(input.length)))
		return input.length;
	else
	{
		size_t total = 0;

		foreach (dchar c; input)
			total += codeLength!C(c);

		return total;
	}
}

///

/+
Internal helper function:

Returns true if it is safe to search for the Codepoint $(D c) inside
code units, without decoding.

This is a runtime check that is used an optimization in various functions,
particularly, in $(D std.string).
  +/
package bool canSearchInCodeUnits(C)(dchar c) if (isSomeChar!C)
{
	static if (C.sizeof == 1)
		return c <= 0x7F;
	else static if (C.sizeof == 2)
		return c <= 0xD7FF || (0xE000 <= c && c <= 0xFFFF);
	else static if (C.sizeof == 4)
		return true;
	else
		static assert(0);
}

unittest
{
	assert(canSearchInCodeUnits!char('a'));
	assert(canSearchInCodeUnits!wchar('a'));
	assert(canSearchInCodeUnits!dchar('a'));
	assert(!canSearchInCodeUnits!char('ö')); //Important test: ö <= 0xFF
	assert(!canSearchInCodeUnits!char(cast(char) 'ö')); //Important test: ö <= 0xFF
	assert(canSearchInCodeUnits!wchar('ö'));
	assert(canSearchInCodeUnits!dchar('ö'));
	assert(!canSearchInCodeUnits!char('日'));
	assert(canSearchInCodeUnits!wchar('日'));
	assert(canSearchInCodeUnits!dchar('日'));
	assert(!canSearchInCodeUnits!wchar(cast(wchar) 0xDA00));
	assert(canSearchInCodeUnits!dchar(cast(dchar) 0xDA00));
	assert(!canSearchInCodeUnits!char('\U00010001'));
	assert(!canSearchInCodeUnits!wchar('\U00010001'));
	assert(canSearchInCodeUnits!dchar('\U00010001'));
}

/* =================== Validation ======================= */

/++
    Checks to see if $(D str) is well-formed unicode or not.

    Throws:
        $(D UTFException) if $(D str) is not well-formed.
  +/
void validate(S)(in S str) @safe pure if (isSomeString!S)
{
	immutable len = str.length;
	for (size_t i = 0; i < len;)
	{
		decode(str, i);
	}
}

/* =================== Conversion to UTF8 ======================= */

pure
{

	char[] toUTF8(return  out char[4] buf, dchar c) nothrow @nogc @safe
	{
		if (c <= 0x7F)
		{
			buf[0] = cast(char) c;
			return buf[0 .. 1];
		}
		else if (c <= 0x7FF)
		{
			buf[0] = cast(char)(0xC0 | (c >> 6));
			buf[1] = cast(char)(0x80 | (c & 0x3F));
			return buf[0 .. 2];
		}
		else if (c <= 0xFFFF)
		{
			if (c >= 0xD800 && c <= 0xDFFF)
				c = replacementDchar;

		L3:
			buf[0] = cast(char)(0xE0 | (c >> 12));
			buf[1] = cast(char)(0x80 | ((c >> 6) & 0x3F));
			buf[2] = cast(char)(0x80 | (c & 0x3F));
			return buf[0 .. 3];
		}
		else
		{
			if (c > 0x10FFFF)
			{
				c = replacementDchar;
				goto L3;
			}

			buf[0] = cast(char)(0xF0 | (c >> 18));
			buf[1] = cast(char)(0x80 | ((c >> 12) & 0x3F));
			buf[2] = cast(char)(0x80 | ((c >> 6) & 0x3F));
			buf[3] = cast(char)(0x80 | (c & 0x3F));
			return buf[0 .. 4];
		}
	}

	

} // Convert functions are @safe

/* =================== toUTFz ======================= */

/++
    Returns a C-style zero-terminated string equivalent to $(D str). $(D str)
    must not contain embedded $(D '\0')'s as any C function will treat the first
    $(D '\0') that it sees as the end of the string. If $(D str.empty) is
    $(D true), then a string containing only $(D '\0') is returned.

    $(D toUTFz) accepts any type of string and is templated on the type of
    character pointer that you wish to convert to. It will avoid allocating a
    new string if it can, but there's a decent chance that it will end up having
    to allocate a new string - particularly when dealing with character types
    other than $(D char).

    $(RED Warning 1:) If the result of $(D toUTFz) equals $(D str.ptr), then if
    anything alters the character one past the end of $(D str) (which is the
    $(D '\0') character terminating the string), then the string won't be
    zero-terminated anymore. The most likely scenarios for that are if you
    append to $(D str) and no reallocation takes place or when $(D str) is a
    slice of a larger array, and you alter the character in the larger array
    which is one character past the end of $(D str). Another case where it could
    occur would be if you had a mutable character array immediately after
    $(D str) in memory (for example, if they're member variables in a
    user-defined type with one declared right after the other) and that
    character array happened to start with $(D '\0'). Such scenarios will never
    occur if you immediately use the zero-terminated string after calling
    $(D toUTFz) and the C function using it doesn't keep a reference to it.
    Also, they are unlikely to occur even if you save the zero-terminated string
    (the cases above would be among the few examples of where it could happen).
    However, if you save the zero-terminate string and want to be absolutely
    certain that the string stays zero-terminated, then simply append a
    $(D '\0') to the string and use its $(D ptr) property rather than calling
    $(D toUTFz).

    $(RED Warning 2:) When passing a character pointer to a C function, and the
    C function keeps it around for any reason, make sure that you keep a
    reference to it in your D code. Otherwise, it may go away during a garbage
    collection cycle and cause a nasty bug when the C code tries to use it.
  +/
template toUTFz(P)
{
	P toUTFz(S)(S str) @safe pure
	{
		return toUTFzImpl!(P, S)(str);
	}
}

///
@safe pure unittest
{
	auto p1 = toUTFz!(char*)("hello world");
	auto p2 = toUTFz!(const(char)*)("hello world");
	auto p3 = toUTFz!(immutable(char)*)("hello world");
	auto p4 = toUTFz!(char*)("hello world"d);
	auto p5 = toUTFz!(const(wchar)*)("hello world");
	auto p6 = toUTFz!(immutable(dchar)*)("hello world"w);
}

private P toUTFzImpl(P, S)(S str) @safe pure 
		if (isSomeString!S && isPointer!P && isSomeChar!(typeof(*P.init))
			&& is(Unqual!(typeof(*P.init)) == Unqual!(ElementEncodingType!S))
			&& is(immutable(Unqual!(ElementEncodingType!S)) == ElementEncodingType!S)) //immutable(C)[] -> C*, const(C)*, or immutable(C)*
			{
	if (str.empty)
	{
		typeof(*P.init)[] retval = ['\0'];

		return retval.ptr;
	}

	alias C = Unqual!(ElementEncodingType!S);

	//If the P is mutable, then we have to make a copy.
	static if (is(Unqual!(typeof(*P.init)) == typeof(*P.init)))
	{
		return toUTFzImpl!(P, const(C)[])(cast(const(C)[]) str);
	}
	else
	{
		if (!__ctfe)
		{
			auto trustedPtrAdd(S s) @trusted
			{
				return s.ptr + s.length;
			}

			immutable p = trustedPtrAdd(str);

			// Peek past end of str, if it's 0, no conversion necessary.
			// Note that the compiler will put a 0 past the end of static
			// strings, and the storage allocator will put a 0 past the end
			// of newly allocated char[]'s.
			// Is p dereferenceable? A simple test: if the p points to an
			// address multiple of 4, then conservatively assume the pointer
			// might be pointing to a new block of memory, which might be
			// unreadable. Otherwise, it's definitely pointing to valid
			// memory.
			if ((cast(size_t) p & 3) && *p == '\0')
				return str.ptr;
		}

		return toUTFzImpl!(P, const(C)[])(cast(const(C)[]) str);
	}
}

private P toUTFzImpl(P, S)(S str) @safe pure 
		if (isSomeString!S && isPointer!P && isSomeChar!(typeof(*P.init))
			&& is(Unqual!(typeof(*P.init)) == Unqual!(ElementEncodingType!S))
			&& !is(immutable(Unqual!(ElementEncodingType!S)) == ElementEncodingType!S)) //C[] or const(C)[] -> C*, const(C)*, or immutable(C)*
			{
	alias InChar = ElementEncodingType!S;
	alias OutChar = typeof(*P.init);

	//const(C)[] -> const(C)* or
	//C[] -> C* or const(C)*
	static if ((is(const(Unqual!InChar) == InChar)
			&& is(const(Unqual!OutChar) == OutChar)) || (!is(const(Unqual!InChar) == InChar)
			&& !is(immutable(Unqual!OutChar) == OutChar)))
	{
		if (!__ctfe)
		{
			auto trustedPtrAdd(S s) @trusted
			{
				return s.ptr + s.length;
			}

			auto p = trustedPtrAdd(str);

			if ((cast(size_t) p & 3) && *p == '\0')
				return str.ptr;
		}

		str ~= '\0';
		return str.ptr;
	}
	//const(C)[] -> C* or immutable(C)* or
	//C[] -> immutable(C)*
	else
	{
		import std.array : uninitializedArray;

		auto copy = uninitializedArray!(Unqual!OutChar[])(str.length + 1);
		copy[0 .. $ - 1] = str[];
		copy[$ - 1] = '\0';

		auto trustedCast(typeof(copy) c) @trusted
		{
			return cast(P) c.ptr;
		}

		return trustedCast(copy);
	}
}

private P toUTFzImpl(P, S)(S str) @safe pure 
		if (isSomeString!S && isPointer!P && isSomeChar!(typeof(*P.init))
			&& !is(Unqual!(typeof(*P.init)) == Unqual!(ElementEncodingType!S))) //C1[], const(C1)[], or immutable(C1)[] -> C2*, const(C2)*, or immutable(C2)*
			{
	import std.array : appender;

	auto retval = appender!(typeof(*P.init)[])();

	foreach (dchar c; str)
		retval.put(c);
	retval.put('\0');

	return cast(P) retval.data.ptr;
}

/++
    $(D toUTF16z) is a convenience function for $(D toUTFz!(const(wchar)*)).

    Encodes string $(D s) into UTF-16 and returns the encoded string.
    $(D toUTF16z) is suitable for calling the 'W' functions in the Win32 API
    that take an $(D LPWSTR) or $(D LPCWSTR) argument.
  +/
const(wchar)* toUTF16z(C)(const(C)[] str) @safe pure if (isSomeChar!C)
{
	return toUTFz!(const(wchar)*)(str);
}

/* ================================ tests ================================== */

/++
    Returns the total number of code points encoded in $(D str).

    Supercedes: This function supercedes $(LREF toUCSindex).

    Standards: Unicode 5.0, ASCII, ISO-8859-1, WINDOWS-1252

    Throws:
        $(D UTFException) if $(D str) is not well-formed.
  +/
size_t count(C)(const(C)[] str) @trusted pure nothrow @nogc if (isSomeChar!C)
{
	return walkLength(str);
}

/**
 * Inserted in place of invalid UTF sequences.
 *
 * References:
 *      $(LINK http://en.wikipedia.org/wiki/Replacement_character#Replacement_character)
 */
enum dchar replacementDchar = '\uFFFD';

/********************************************
 * Iterate a range of char, wchar, or dchars by code unit.
 *
 * The purpose is to bypass the special case decoding that
 * $(XREF array,front) does to character arrays.
 * Params:
 *      r = input range of characters, or array of characters
 * Returns:
 *      input range
 */

auto byCodeUnit(R)(R r) if (isAutodecodableString!R)
{
	/* Turn an array into an InputRange.
     */
	static struct ByCodeUnitImpl
	{
	pure nothrow @nogc:

		@property bool empty() const
		{
			return r.length == 0;
		}

		@property auto ref front() inout
		{
			return r[0];
		}

		void popFront()
		{
			r = r[1 .. $];
		}

		auto ref opIndex(size_t index) inout
		{
			return r[index];
		}

		@property auto ref back() inout
		{
			return r[$ - 1];
		}

		void popBack()
		{
			r = r[0 .. $ - 1];
		}

		static if (!isAggregateType!R)
		{
			auto opSlice(size_t lower, size_t upper)
			{
				return ByCodeUnitImpl(r[lower .. upper]);
			}
		}

		@property size_t length() const
		{
			return r.length;
		}

		alias opDollar = length;

		static if (!isAggregateType!R)
		{
			@property auto save()
			{
				return ByCodeUnitImpl(r.save);
			}
		}

	private:
		R r;
	}

	static assert(isAggregateType!R || isRandomAccessRange!ByCodeUnitImpl);

	return ByCodeUnitImpl(r);
}

/// Ditto
auto ref byCodeUnit(R)(R r)
		if (!isAutodecodableString!R && isInputRange!R && isSomeChar!(ElementEncodingType!R))
{
	// byCodeUnit for ranges and dchar[] is a no-op
	return r;
}

/****************************
 * Iterate an input range of characters by char, wchar, or dchar.
 * These aliases simply forward to $(LREF byUTF) with the
 * corresponding C argument.
 *
 * Params:
 *      r = input range of characters, or array of characters
 */
alias byChar = byUTF!char;

/// Ditto
alias byWchar = byUTF!wchar;

/// Ditto
alias byDchar = byUTF!dchar;

// test pure, @safe, nothrow, @nogc correctness of byChar/byWchar/byDchar,
// which needs to support ranges with and without those attributes

pure @safe nothrow @nogc unittest
{
	dchar[5] s = "hello"d;
	foreach (c; s[].byChar())
	{
	}
	foreach (c; s[].byWchar())
	{
	}
	foreach (c; s[].byDchar())
	{
	}
}

/****************************
 * Iterate an input range of characters by char type C.
 *
 * UTF sequences that cannot be converted to UTF-8 are replaced by U+FFFD
 * per "5.22 Best Practice for U+FFFD Substitution" of the Unicode Standard 6.2.
 * Hence byUTF is not symmetric.
 * This algorithm is lazy, and does not allocate memory.
 * Purity, nothrow, and safety are inferred from the r parameter.
 *
 * Params:
 *      C = char, wchar, or dchar
 *      r = input range of characters, or array of characters
 * Returns:
 *      input range of type C
 */
template byUTF(C) if (isSomeChar!C)
{
	static if (!is(Unqual!C == C))
		alias byUTF = byUTF!(Unqual!C);
	else:

		auto ref byUTF(R)(R r)
				if (isAutodecodableString!R && isInputRange!R
					&& isSomeChar!(ElementEncodingType!R))
		{
			return byUTF(r.byCodeUnit());
		}

	auto ref byUTF(R)(R r)
			if (!isAutodecodableString!R && isInputRange!R && isSomeChar!(ElementEncodingType!R))
	{
		alias RC = Unqual!(ElementEncodingType!R);

		static if (is(RC == C))
		{
			return r.byCodeUnit();
		}
		else
		{
			static struct Result
			{
				this(ref R r)
				{
					this.r = r;
				}

				@property bool empty()
				{
					return pos == fill && r.empty;
				}

				@property auto front()
				{
					if (pos == fill)
					{
						pos = 0;
						fill = cast(ushort) encode!(UseReplacementDchar.yes)(buf,
								decodeFront!(UseReplacementDchar.yes)(r));
					}
					return buf[pos];
				}

				void popFront()
				{
					if (pos == fill)
						front;
					++pos;
				}

				static if (isForwardRange!R)
				{
					@property auto save()
					{
						auto ret = this;
						ret.r = r.save;
						return ret;
					}
				}

			private:

				R r;
				C[4 / C.sizeof] buf = void;
				ushort pos, fill;
			}

			return Result(r);
		}
	}
}

///
@safe pure nothrow @nogc unittest
{
	foreach (c; "h".byUTF!char())
		assert(c == 'h');
	foreach (c; "h".byUTF!wchar())
		assert(c == 'h');
	foreach (c; "h".byUTF!dchar())
		assert(c == 'h');
}
