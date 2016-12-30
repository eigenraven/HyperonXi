// Written in the D programming language.

/**
Bit-level manipulation facilities.

Macros:

WIKI = StdBitarray

Copyright: Copyright Digital Mars 2007 - 2011.
License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors:   $(WEB digitalmars.com, Walter Bright),
           $(WEB erdani.org, Andrei Alexandrescu),
           Jonathan M Davis,
           Alex Rønne Petersen,
           Damian Ziemba
           Amaury SECHET
Source: $(PHOBOSSRC std/_bitmanip.d)
*/
/*
         Copyright Digital Mars 2007 - 2012.
Distributed under the Boost Software License, Version 1.0.
   (See accompanying file LICENSE_1_0.txt or copy at
         http://www.boost.org/LICENSE_1_0.txt)
*/
module std.bitmanip;

//debug = bitarray;                // uncomment to turn on debugging printf's

import std.range.primitives;

enum Endian
{
	bigEndian,
	littleEndian
}

import std.traits;

version (unittest)
{
	import std.stdio;
}

private string myToString(ulong n)
{
	import core.internal.string;

	if (__ctfe)
	{
		UnsignedStringBuf buf;
		auto s = unsignedToTempString(n, buf);
		return cast(string) s ~ (n > uint.max ? "UL" : "U");
	}
	else
		return "";
}

private template createAccessors(string store, T, string name, size_t len, size_t offset)
{
	static if (!name.length)
	{
		// No need to create any accessor
		enum result = "";
	}
	else static if (len == 0)
	{
		// Fields of length 0 are always zero
		enum result = "enum " ~ T.stringof ~ " " ~ name ~ " = 0;\n";
	}
	else
	{
		enum ulong maskAllElse = ((~0uL) >> (64 - len)) << offset, signBitCheck = 1uL << (len - 1);

		static if (T.min < 0)
		{
			enum long minVal = -(1uL << (len - 1));
			enum ulong maxVal = (1uL << (len - 1)) - 1;
			alias UT = Unsigned!(T);
			enum UT extendSign = cast(UT)~((~0uL) >> (64 - len));
		}
		else
		{
			enum ulong minVal = 0;
			enum ulong maxVal = (~0uL) >> (64 - len);
			enum extendSign = 0;
		}

		static if (is(T == bool))
		{
			static assert(len == 1);
			enum result = // getter
					"@property bool " ~ name ~ "() @safe pure nothrow @nogc const { return " ~ "(" ~ store ~ " & "
					~ myToString(maskAllElse) ~ ") != 0;}\n"// setter
					 ~ "@property void "
					~ name ~ "(bool v) @safe pure nothrow @nogc { " ~ "if (v) " ~ store ~ " |= " ~ myToString(
							maskAllElse) ~ ";" ~ "else " ~ store ~ " &= ~cast(typeof(" ~ store ~ "))" ~ myToString(
							maskAllElse) ~ ";}\n";
		}
		else
		{
			// getter
			enum result = "@property " ~ T.stringof ~ " " ~ name ~ "() @safe pure nothrow @nogc const { auto result = "
					~ "(" ~ store ~ " & " ~ myToString(maskAllElse) ~ ") >>" ~ myToString(offset) ~ ";" ~ (T.min < 0
							? "if (result >= " ~ myToString(
								signBitCheck) ~ ") result |= " ~ myToString(extendSign) ~ ";" : "")
					~ " return cast(" ~ T.stringof ~ ") result;}\n"// setter
					
					~ "@property void " ~ name ~ "(" ~ T.stringof ~ " v) @safe pure nothrow @nogc { "
					~ "assert(v >= " ~ name
					~ `_min, "Value is smaller than the minimum value of bitfield '` ~ name ~ `'"); ` ~ "assert(v <= "
					~ name ~ `_max, "Value is greater than the maximum value of bitfield '`
					~ name ~ `'"); ` ~ store ~ " = cast(typeof(" ~ store
					~ "))" ~ " ((" ~ store ~ " & ~cast(typeof(" ~ store ~ "))" ~ myToString(
							maskAllElse) ~ ")" ~ " | ((cast(typeof(" ~ store ~ ")) v << " ~ myToString(
							offset) ~ ")" ~ " & " ~ myToString(maskAllElse) ~ "));}\n"// constants
					 ~ "enum " ~ T.stringof ~ " "
					~ name ~ "_min = cast(" ~ T.stringof ~ ")" ~ myToString(
							minVal) ~ "; " ~ " enum " ~ T.stringof ~ " " ~ name
					~ "_max = cast(" ~ T.stringof ~ ")" ~ myToString(maxVal) ~ "; ";
		}
	}
}

private template createStoreName(Ts...)
{
	static if (Ts.length < 2)
		enum createStoreName = "";
	else
		enum createStoreName = "_" ~ Ts[1] ~ createStoreName!(Ts[3 .. $]);
}

private template createFields(string store, size_t offset, Ts...)
{
	static if (!Ts.length)
	{
		static if (offset == ubyte.sizeof * 8)
			alias StoreType = ubyte;
		else static if (offset == ushort.sizeof * 8)
			alias StoreType = ushort;
		else static if (offset == uint.sizeof * 8)
			alias StoreType = uint;
		else static if (offset == ulong.sizeof * 8)
			alias StoreType = ulong;
		else
		{
			static assert(false, "Field widths must sum to 8, 16, 32, or 64");
			alias StoreType = ulong; // just to avoid another error msg
		}
		enum result = "private " ~ StoreType.stringof ~ " " ~ store ~ ";";
	}
	else
	{
		enum result = createAccessors!(store, Ts[0], Ts[1], Ts[2], offset).result ~ createFields!(store,
					offset + Ts[2], Ts[3 .. $]).result;
	}
}

private ulong getBitsForAlign(ulong a)
{
	ulong bits = 0;
	while ((a & 0x01) == 0)
	{
		bits++;
		a >>= 1;
	}

	assert(a == 1, "alignment is not a power of 2");
	return bits;
}

private template createReferenceAccessor(string store, T, ulong bits, string name)
{
	enum mask = (1UL << bits) - 1;
	// getter
	enum result = "@property " ~ T.stringof ~ " " ~ name
			~ "() @trusted pure nothrow @nogc const { auto result = " ~ "(" ~ store ~ " & "
			~ myToString(~mask) ~ ");" ~ " return cast(" ~ T.stringof
			~ ") cast(void*) result;}\n"// setter
			 ~ "@property void " ~ name ~ "(" ~ T.stringof
			~ " v) @trusted pure nothrow @nogc { " ~ "assert(((cast(typeof("
			~ store ~ ")) cast(void*) v) & " ~ myToString(mask)
			~ `) == 0, "Value not properly aligned for '` ~ name ~ `'"); ` ~ store
			~ " = cast(typeof(" ~ store ~ "))" ~ " ((" ~ store ~ " & (cast(typeof(" ~ store ~ ")) " ~ myToString(
					mask) ~ "))" ~ " | ((cast(typeof(" ~ store ~ ")) cast(void*) v) & (cast(typeof("
			~ store ~ ")) " ~ myToString(~mask) ~ ")));}\n";
}

private template sizeOfBitField(T...)
{
	static if (T.length < 2)
		enum sizeOfBitField = 0;
	else
		enum sizeOfBitField = T[2] + sizeOfBitField!(T[3 .. $]);
}

private template createTaggedReference(string store, T, ulong a, string name, Ts...)
{
	static assert(sizeOfBitField!Ts <= getBitsForAlign(a),
			"Fields must fit in the bits know to be zero because of alignment.");
	enum result = createReferenceAccessor!(store, T, sizeOfBitField!Ts, name).result ~ createFields!(store,
				0, Ts, size_t, "", T.sizeof * 8 - sizeOfBitField!Ts).result;
}

/**
Allows creating bit fields inside $(D_PARAM struct)s and $(D_PARAM
class)es.

Example:

----
struct A
{
    int a;
    mixin(bitfields!(
        uint, "x",    2,
        int,  "y",    3,
        uint, "z",    2,
        bool, "flag", 1));
}
A obj;
obj.x = 2;
obj.z = obj.x;
----

The example above creates a bitfield pack of eight bits, which fit in
one $(D_PARAM ubyte). The bitfields are allocated starting from the
least significant bit, i.e. x occupies the two least significant bits
of the bitfields storage.

The sum of all bit lengths in one $(D_PARAM bitfield) instantiation
must be exactly 8, 16, 32, or 64. If padding is needed, just allocate
one bitfield with an empty name.

Example:

----
struct A
{
    mixin(bitfields!(
        bool, "flag1",    1,
        bool, "flag2",    1,
        uint, "",         6));
}
----

The type of a bit field can be any integral type or enumerated
type. The most efficient type to store in bitfields is $(D_PARAM
bool), followed by unsigned types, followed by signed types.
*/

template bitfields(T...)
{
	enum
	{
		bitfields = createFields!(createStoreName!(T), 0, T).result
	}
}

/**
This string mixin generator allows one to create tagged pointers inside $(D_PARAM struct)s and $(D_PARAM class)es.

A tagged pointer uses the bits known to be zero in a normal pointer or class reference to store extra information.
For example, a pointer to an integer must be 4-byte aligned, so there are 2 bits that are always known to be zero.
One can store a 2-bit integer there.

The example above creates a tagged pointer in the struct A. The pointer is of type
$(D uint*) as specified by the first argument, and is named x, as specified by the second
argument.

Following arguments works the same way as $(D bitfield)'s. The bitfield must fit into the
bits known to be zero because of the pointer alignment.

$(RED Warning: Don't use $(D taggedPointer) with pointers to garbage collected objects, as it will result in
undefined behaviour. See
$(DDLINK spec/garbage, Garbage Collection, Garbage Collection) for details.)
*/

template taggedPointer(T : T*, string name, Ts...)
{
	enum taggedPointer = createTaggedReference!(createStoreName!(T, name, 0,
				Ts), T*, T.alignof, name, Ts).result;
}

///
unittest
{
	struct A
	{
		int a;
		mixin(taggedPointer!(uint*, "x", bool, "b1", 1, bool, "b2", 1));
	}

	A obj;
	obj.x = new uint;
	obj.b1 = true;
	obj.b2 = false;
}

/**
This string mixin generator allows one to create tagged class reference inside $(D_PARAM struct)s and $(D_PARAM class)es.

A tagged class reference uses the bits known to be zero in a normal class reference to store extra information.
For example, a pointer to an integer must be 4-byte aligned, so there are 2 bits that are always known to be zero.
One can store a 2-bit integer there.

The example above creates a tagged reference to an Object in the struct A. This expects the same parameters
as $(D taggedPointer), except the first argument which must be a class type instead of a pointer type.

$(RED Warning: Don't use $(D taggedClassRef) with references to garbage collected objects, as it will result in
undefined behaviour. See
$(DDLINK spec/garbage, Garbage Collection, Garbage Collection) for details.)
*/

template taggedClassRef(T, string name, Ts...) if (is(T == class))
{
	enum taggedClassRef = createTaggedReference!(createStoreName!(T, name, 0, Ts), T, 8, name, Ts)
			.result;
}

///
unittest
{
	struct A
	{
		int a;
		mixin(taggedClassRef!(Object, "o", uint, "i", 2));
	}

	A obj;
	obj.o = new Object();
	obj.i = 3;
}

@safe pure nothrow @nogc unittest
{
	// Degenerate bitfields (#8474 / #11160) tests mixed with range tests
	struct Test1
	{
		mixin(bitfields!(uint, "a", 32, uint, "b", 4, uint, "c", 4, uint, "d", 8, uint, "e", 16,));

		static assert(Test1.b_min == 0);
		static assert(Test1.b_max == 15);
	}

	struct Test2
	{
		mixin(bitfields!(bool, "a", 0, ulong, "b", 64));

		static assert(Test2.b_min == ulong.min);
		static assert(Test2.b_max == ulong.max);
	}

	struct Test1b
	{
		mixin(bitfields!(bool, "a", 0, int, "b", 8));
	}

	struct Test2b
	{
		mixin(bitfields!(int, "a", 32, int, "b", 4, int, "c", 4, int, "d", 8, int, "e", 16,));

		static assert(Test2b.b_min == -8);
		static assert(Test2b.b_max == 7);
	}

	struct Test3b
	{
		mixin(bitfields!(bool, "a", 0, long, "b", 64));

		static assert(Test3b.b_min == long.min);
		static assert(Test3b.b_max == long.max);
	}

	struct Test4b
	{
		mixin(bitfields!(long, "a", 32, int, "b", 32));
	}

	// Sign extension tests
	Test2b t2b;
	Test4b t4b;
	t2b.b = -5;
	assert(t2b.b == -5);
	t2b.d = -5;
	assert(t2b.d == -5);
	t2b.e = -5;
	assert(t2b.e == -5);
	t4b.a = -5;
	assert(t4b.a == -5L);
}

unittest
{
	struct Test5
	{
		mixin(taggedPointer!(int*, "a", uint, "b", 2));
	}

	Test5 t5;
	t5.a = null;
	t5.b = 3;
	assert(t5.a is null);
	assert(t5.b == 3);

	int myint = 42;
	t5.a = &myint;
	assert(t5.a is &myint);
	assert(t5.b == 3);

	struct Test6
	{
		mixin(taggedClassRef!(Object, "o", bool, "b", 1));
	}

	Test6 t6;
	t6.o = null;
	t6.b = false;
	assert(t6.o is null);
	assert(t6.b == false);

	auto o = new Object();
	t6.o = o;
	t6.b = true;
	assert(t6.o is o);
	assert(t6.b == true);
}

unittest
{
	static assert(!__traits(compiles, taggedPointer!(int*, "a", uint, "b", 3)));

	static assert(!__traits(compiles, taggedClassRef!(Object, "a", uint, "b", 4)));
}

unittest
{
	// Bug #6686
	union S
	{
		ulong bits = ulong.max;
		mixin(bitfields!(ulong, "back", 31, ulong, "front", 33));
	}

	S num;

	num.bits = ulong.max;
	num.back = 1;
	assert(num.bits == 0xFFFF_FFFF_8000_0001uL);
}

unittest
{
	// Bug #5942
	struct S
	{
		mixin(bitfields!(int, "a", 32, int, "b", 32));
	}

	S data;
	data.b = 42;
	data.a = 1;
	assert(data.b == 42);
}

unittest
{
	struct Test
	{
		mixin(bitfields!(bool, "a", 1, uint, "b", 3, short, "c", 4));
	}

	@safe void test() pure nothrow
	{
		Test t;

		t.a = true;
		t.b = 5;
		t.c = 2;

		assert(t.a);
		assert(t.b == 5);
		assert(t.c == 2);
	}

	test();
}

unittest
{
	{
		static struct Integrals
		{
			bool checkExpectations(bool eb, int ei, short es)
			{
				return b == eb && i == ei && s == es;
			}

			mixin(bitfields!(bool, "b", 1, uint, "i", 3, short, "s", 4));
		}

		Integrals i;
		assert(i.checkExpectations(false, 0, 0));
		i.b = true;
		assert(i.checkExpectations(true, 0, 0));
		i.i = 7;
		assert(i.checkExpectations(true, 7, 0));
		i.s = -8;
		assert(i.checkExpectations(true, 7, -8));
		i.s = 7;
		assert(i.checkExpectations(true, 7, 7));
	}

	//Bug# 8876
	{
		struct MoreIntegrals
		{
			bool checkExpectations(uint eu, ushort es, uint ei)
			{
				return u == eu && s == es && i == ei;
			}

			mixin(bitfields!(uint, "u", 24, short, "s", 16, int, "i", 24));
		}

		MoreIntegrals i;
		assert(i.checkExpectations(0, 0, 0));
		i.s = 20;
		assert(i.checkExpectations(0, 20, 0));
		i.i = 72;
		assert(i.checkExpectations(0, 20, 72));
		i.u = 8;
		assert(i.checkExpectations(8, 20, 72));
		i.s = 7;
		assert(i.checkExpectations(8, 7, 72));
	}

	enum A
	{
		True,
		False
	}

	enum B
	{
		One,
		Two,
		Three,
		Four
	}

	static struct Enums
	{
		bool checkExpectations(A ea, B eb)
		{
			return a == ea && b == eb;
		}

		mixin(bitfields!(A, "a", 1, B, "b", 2, uint, "", 5));
	}

	Enums e;
	assert(e.checkExpectations(A.True, B.One));
	e.a = A.False;
	assert(e.checkExpectations(A.False, B.One));
	e.b = B.Three;
	assert(e.checkExpectations(A.False, B.Three));

	static struct SingleMember
	{
		bool checkExpectations(bool eb)
		{
			return b == eb;
		}

		mixin(bitfields!(bool, "b", 1, uint, "", 7));
	}

	SingleMember f;
	assert(f.checkExpectations(false));
	f.b = true;
	assert(f.checkExpectations(true));
}

// Issue 12477
unittest
{
	import std.algorithm : canFind;
	import std.bitmanip : bitfields;
	import core.exception : AssertError;

	static struct S
	{
		mixin(bitfields!(uint, "a", 6, int, "b", 2));
	}

	S s;

	try
	{
		s.a = uint.max;
		assert(0);
	}
	catch (AssertError ae)
	{
		assert(ae.msg.canFind("Value is greater than the maximum value of bitfield 'a'"), ae.msg);
	}

	try
	{
		s.b = int.min;
		assert(0);
	}
	catch (AssertError ae)
	{
		assert(ae.msg.canFind("Value is smaller than the minimum value of bitfield 'b'"), ae.msg);
	}
}

/**
   Allows manipulating the fraction, exponent, and sign parts of a
   $(D_PARAM float) separately. The definition is:

----
struct FloatRep
{
    union
    {
        float value;
        mixin(bitfields!(
                  uint,  "fraction", 23,
                  ubyte, "exponent",  8,
                  bool,  "sign",      1));
    }
    enum uint bias = 127, fractionBits = 23, exponentBits = 8, signBits = 1;
}
----
*/

struct FloatRep
{
	union
	{
		float value;
		mixin(bitfields!(uint, "fraction", 23, ubyte, "exponent", 8, bool, "sign", 1));
	}

	enum uint bias = 127, fractionBits = 23, exponentBits = 8, signBits = 1;
}

/**
   Allows manipulating the fraction, exponent, and sign parts of a
   $(D_PARAM double) separately. The definition is:

----
struct DoubleRep
{
    union
    {
        double value;
        mixin(bitfields!(
                  ulong,   "fraction", 52,
                  ushort,  "exponent", 11,
                  bool,    "sign",      1));
    }
    enum uint bias = 1023, signBits = 1, fractionBits = 52, exponentBits = 11;
}
----
*/

struct DoubleRep
{
	union
	{
		double value;
		mixin(bitfields!(ulong, "fraction", 52, ushort, "exponent", 11, bool, "sign", 1));
	}

	enum uint bias = 1023, signBits = 1, fractionBits = 52, exponentBits = 11;
}

unittest
{
	// test reading
	DoubleRep x;
	x.value = 1.0;
	assert(x.fraction == 0 && x.exponent == 1023 && !x.sign);
	x.value = -0.5;
	assert(x.fraction == 0 && x.exponent == 1022 && x.sign);
	x.value = 0.5;
	assert(x.fraction == 0 && x.exponent == 1022 && !x.sign);

	// test writing
	x.fraction = 1125899906842624;
	x.exponent = 1025;
	x.sign = true;
	assert(x.value == -5.0);

	// test enums
	enum ABC
	{
		A,
		B,
		C
	}

	struct EnumTest
	{
		mixin(bitfields!(ABC, "x", 2, bool, "y", 1, ubyte, "z", 5));
	}
}

unittest
{
	// Issue #15305
	struct S
	{
		mixin(bitfields!(bool, "alice", 1, ulong, "bob", 63,));
	}

	S s;
	s.bob = long.max - 1;
	s.alice = false;
	assert(s.bob == long.max - 1);
}

/++
    Swaps the endianness of the given integral value or character.
  +/
T swapEndian(T)(T val) @safe pure nothrow @nogc 
		if (isIntegral!T || isSomeChar!T || isBoolean!T)
{
	static if (val.sizeof == 1)
		return val;
	else static if (isUnsigned!T)
		return swapEndianImpl(val);
	else static if (isIntegral!T)
		return cast(T) swapEndianImpl(cast(Unsigned!T) val);
	else static if (is(Unqual!T == wchar))
		return cast(T) swapEndian(cast(ushort) val);
	else static if (is(Unqual!T == dchar))
		return cast(T) swapEndian(cast(uint) val);
	else
		static assert(0, T.stringof ~ " unsupported by swapEndian.");
}

private ushort swapEndianImpl(ushort val) @safe pure nothrow @nogc
{
	return ((val & 0xff00U) >> 8) | ((val & 0x00ffU) << 8);
}

private uint swapEndianImpl(uint val) @trusted pure nothrow @nogc
{
	import core.bitop : bswap;

	return bswap(val);
}

private ulong swapEndianImpl(ulong val) @trusted pure nothrow @nogc
{
	import core.bitop : bswap;

	immutable ulong res = bswap(cast(uint) val);
	return res << 32 | bswap(cast(uint)(val >> 32));
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(bool, byte, ubyte, short, ushort, int, uint, long,
			ulong, char, wchar, dchar))
	{
		scope (failure)
			writefln("Failed type: %s", T.stringof);
		T val;
		const T cval;
		immutable T ival;

		assert(swapEndian(swapEndian(val)) == val);
		assert(swapEndian(swapEndian(cval)) == cval);
		assert(swapEndian(swapEndian(ival)) == ival);
		assert(swapEndian(swapEndian(T.min)) == T.min);
		assert(swapEndian(swapEndian(T.max)) == T.max);

		foreach (i; 2 .. 10)
		{
			immutable T maxI = cast(T)(T.max / i);
			immutable T minI = cast(T)(T.min / i);

			assert(swapEndian(swapEndian(maxI)) == maxI);

			static if (isSigned!T)
				assert(swapEndian(swapEndian(minI)) == minI);
		}

		static if (isSigned!T)
			assert(swapEndian(swapEndian(cast(T) 0)) == 0);

		// used to trigger BUG6354
		static if (T.sizeof > 1 && isUnsigned!T)
		{
			T left = 0xffU;
			left <<= (T.sizeof - 1) * 8;
			T right = 0xffU;

			for (size_t i = 1; i < T.sizeof; ++i)
			{
				assert(swapEndian(left) == right);
				assert(swapEndian(right) == left);
				left >>= 8;
				right <<= 8;
			}
		}
	}
}

private union EndianSwapper(T) if (canSwapEndianness!T)
{
	Unqual!T value;
	ubyte[T.sizeof] array;

	static if (is(FloatingPointTypeOf!T == float))
		uint intValue;
	else static if (is(FloatingPointTypeOf!T == double))
		ulong intValue;

}

/++
    Converts the given value from the native endianness to big endian and
    returns it as a $(D ubyte[n]) where $(D n) is the size of the given type.

    Returning a $(D ubyte[n]) helps prevent accidentally using a swapped value
    as a regular one (and in the case of floating point values, it's necessary,
    because the FPU will mess up any swapped floating point values. So, you
    can't actually have swapped floating point values as floating point values).

    $(D real) is not supported, because its size is implementation-dependent
    and therefore could vary from machine to machine (which could make it
    unusable if you tried to transfer it to another machine).
  +/
auto nativeToBigEndian(T)(T val) @safe pure nothrow @nogc if (canSwapEndianness!T)
{
	return nativeToBigEndianImpl(val);
}

///
unittest
{
	int i = 12345;
	ubyte[4] swappedI = nativeToBigEndian(i);
	assert(i == bigEndianToNative!int(swappedI));

	double d = 123.45;
	ubyte[8] swappedD = nativeToBigEndian(d);
	assert(d == bigEndianToNative!double(swappedD));
}

private auto nativeToBigEndianImpl(T)(T val) @safe pure nothrow @nogc 
		if (isIntegral!T || isSomeChar!T || isBoolean!T)
{
	EndianSwapper!T es = void;

	version (LittleEndian)
		es.value = swapEndian(val);
	else
		es.value = val;

	return es.array;
}

private auto nativeToBigEndianImpl(T)(T val) @safe pure nothrow @nogc 
		if (isFloatOrDouble!T)
{
	version (LittleEndian)
		return floatEndianImpl!(T, true)(val);
	else
		return floatEndianImpl!(T, false)(val);
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(bool, byte, ubyte, short, ushort, int, uint, long,
			ulong, char, wchar, dchar/* The trouble here is with floats and doubles being compared against nan
         * using a bit compare. There are two kinds of nans, quiet and signaling.
         * When a nan passes through the x87, it converts signaling to quiet.
         * When a nan passes through the XMM, it does not convert signaling to quiet.
         * float.init is a signaling nan.
         * The binary API sometimes passes the data through the XMM, sometimes through
         * the x87, meaning these will fail the 'is' bit compare under some circumstances.
         * I cannot think of a fix for this that makes consistent sense.
         */
			/*,float, double*/
		))
	{
		scope (failure)
			writefln("Failed type: %s", T.stringof);
		T val;
		const T cval;
		immutable T ival;

		//is instead of == because of NaN for floating point values.
		assert(bigEndianToNative!T(nativeToBigEndian(val)) is val);
		assert(bigEndianToNative!T(nativeToBigEndian(cval)) is cval);
		assert(bigEndianToNative!T(nativeToBigEndian(ival)) is ival);
		assert(bigEndianToNative!T(nativeToBigEndian(T.min)) == T.min);
		assert(bigEndianToNative!T(nativeToBigEndian(T.max)) == T.max);

		static if (isSigned!T)
			assert(bigEndianToNative!T(nativeToBigEndian(cast(T) 0)) == 0);

		static if (!is(T == bool))
		{
			foreach (i; [2, 4, 6, 7, 9, 11])
			{
				immutable T maxI = cast(T)(T.max / i);
				immutable T minI = cast(T)(T.min / i);

				assert(bigEndianToNative!T(nativeToBigEndian(maxI)) == maxI);

				static if (T.sizeof > 1)
					assert(nativeToBigEndian(maxI) != nativeToLittleEndian(maxI));
				else
					assert(nativeToBigEndian(maxI) == nativeToLittleEndian(maxI));

				static if (isSigned!T)
				{
					assert(bigEndianToNative!T(nativeToBigEndian(minI)) == minI);

					static if (T.sizeof > 1)
						assert(nativeToBigEndian(minI) != nativeToLittleEndian(minI));
					else
						assert(nativeToBigEndian(minI) == nativeToLittleEndian(minI));
				}
			}
		}

		static if (isUnsigned!T || T.sizeof == 1 || is(T == wchar))
			assert(nativeToBigEndian(T.max) == nativeToLittleEndian(T.max));
		else
			assert(nativeToBigEndian(T.max) != nativeToLittleEndian(T.max));

		static if (isUnsigned!T || T.sizeof == 1 || isSomeChar!T)
			assert(nativeToBigEndian(T.min) == nativeToLittleEndian(T.min));
		else
			assert(nativeToBigEndian(T.min) != nativeToLittleEndian(T.min));
	}
}

/++
    Converts the given value from big endian to the native endianness and
    returns it. The value is given as a $(D ubyte[n]) where $(D n) is the size
    of the target type. You must give the target type as a template argument,
    because there are multiple types with the same size and so the type of the
    argument is not enough to determine the return type.

    Taking a $(D ubyte[n]) helps prevent accidentally using a swapped value
    as a regular one (and in the case of floating point values, it's necessary,
    because the FPU will mess up any swapped floating point values. So, you
    can't actually have swapped floating point values as floating point values).
  +/
T bigEndianToNative(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if (canSwapEndianness!T && n == T.sizeof)
{
	return bigEndianToNativeImpl!(T, n)(val);
}

///
unittest
{
	ushort i = 12345;
	ubyte[2] swappedI = nativeToBigEndian(i);
	assert(i == bigEndianToNative!ushort(swappedI));

	dchar c = 'D';
	ubyte[4] swappedC = nativeToBigEndian(c);
	assert(c == bigEndianToNative!dchar(swappedC));
}

private T bigEndianToNativeImpl(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if ((isIntegral!T || isSomeChar!T || isBoolean!T) && n == T.sizeof)
{
	EndianSwapper!T es = void;
	es.array = val;

	version (LittleEndian)
		immutable retval = swapEndian(es.value);
	else
		immutable retval = es.value;

	return retval;
}

private T bigEndianToNativeImpl(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if (isFloatOrDouble!T && n == T.sizeof)
{
	version (LittleEndian)
		return cast(T) floatEndianImpl!(n, true)(val);
	else
		return cast(T) floatEndianImpl!(n, false)(val);
}

/++
    Converts the given value from the native endianness to little endian and
    returns it as a $(D ubyte[n]) where $(D n) is the size of the given type.

    Returning a $(D ubyte[n]) helps prevent accidentally using a swapped value
    as a regular one (and in the case of floating point values, it's necessary,
    because the FPU will mess up any swapped floating point values. So, you
    can't actually have swapped floating point values as floating point values).
  +/
auto nativeToLittleEndian(T)(T val) @safe pure nothrow @nogc 
		if (canSwapEndianness!T)
{
	return nativeToLittleEndianImpl(val);
}

///
unittest
{
	int i = 12345;
	ubyte[4] swappedI = nativeToLittleEndian(i);
	assert(i == littleEndianToNative!int(swappedI));

	double d = 123.45;
	ubyte[8] swappedD = nativeToLittleEndian(d);
	assert(d == littleEndianToNative!double(swappedD));
}

private auto nativeToLittleEndianImpl(T)(T val) @safe pure nothrow @nogc 
		if (isIntegral!T || isSomeChar!T || isBoolean!T)
{
	EndianSwapper!T es = void;

	version (BigEndian)
		es.value = swapEndian(val);
	else
		es.value = val;

	return es.array;
}

private auto nativeToLittleEndianImpl(T)(T val) @safe pure nothrow @nogc 
		if (isFloatOrDouble!T)
{
	version (BigEndian)
		return floatEndianImpl!(T, true)(val);
	else
		return floatEndianImpl!(T, false)(val);
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(bool, byte, ubyte, short, ushort, int, uint, long,
			ulong, char, wchar, dchar /*,
                         float, double*/
		))
	{
		scope (failure)
			writefln("Failed type: %s", T.stringof);
		T val;
		const T cval;
		immutable T ival;

		//is instead of == because of NaN for floating point values.
		assert(littleEndianToNative!T(nativeToLittleEndian(val)) is val);
		assert(littleEndianToNative!T(nativeToLittleEndian(cval)) is cval);
		assert(littleEndianToNative!T(nativeToLittleEndian(ival)) is ival);
		assert(littleEndianToNative!T(nativeToLittleEndian(T.min)) == T.min);
		assert(littleEndianToNative!T(nativeToLittleEndian(T.max)) == T.max);

		static if (isSigned!T)
			assert(littleEndianToNative!T(nativeToLittleEndian(cast(T) 0)) == 0);

		static if (!is(T == bool))
		{
			foreach (i; 2 .. 10)
			{
				immutable T maxI = cast(T)(T.max / i);
				immutable T minI = cast(T)(T.min / i);

				assert(littleEndianToNative!T(nativeToLittleEndian(maxI)) == maxI);

				static if (isSigned!T)
					assert(littleEndianToNative!T(nativeToLittleEndian(minI)) == minI);
			}
		}
	}
}

/++
    Converts the given value from little endian to the native endianness and
    returns it. The value is given as a $(D ubyte[n]) where $(D n) is the size
    of the target type. You must give the target type as a template argument,
    because there are multiple types with the same size and so the type of the
    argument is not enough to determine the return type.

    Taking a $(D ubyte[n]) helps prevent accidentally using a swapped value
    as a regular one (and in the case of floating point values, it's necessary,
    because the FPU will mess up any swapped floating point values. So, you
    can't actually have swapped floating point values as floating point values).

    $(D real) is not supported, because its size is implementation-dependent
    and therefore could vary from machine to machine (which could make it
    unusable if you tried to transfer it to another machine).
  +/
T littleEndianToNative(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if (canSwapEndianness!T && n == T.sizeof)
{
	return littleEndianToNativeImpl!T(val);
}

///
unittest
{
	ushort i = 12345;
	ubyte[2] swappedI = nativeToLittleEndian(i);
	assert(i == littleEndianToNative!ushort(swappedI));

	dchar c = 'D';
	ubyte[4] swappedC = nativeToLittleEndian(c);
	assert(c == littleEndianToNative!dchar(swappedC));
}

private T littleEndianToNativeImpl(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if ((isIntegral!T || isSomeChar!T || isBoolean!T) && n == T.sizeof)
{
	EndianSwapper!T es = void;
	es.array = val;

	version (BigEndian)
		immutable retval = swapEndian(es.value);
	else
		immutable retval = es.value;

	return retval;
}

private T littleEndianToNativeImpl(T, size_t n)(ubyte[n] val) @safe pure nothrow @nogc 
		if (((isFloatOrDouble!T) && n == T.sizeof))
{
	version (BigEndian)
		return floatEndianImpl!(n, true)(val);
	else
		return floatEndianImpl!(n, false)(val);
}

private auto floatEndianImpl(T, bool swap)(T val) @safe pure nothrow @nogc 
		if (isFloatOrDouble!T)
{
	EndianSwapper!T es = void;
	es.value = val;

	static if (swap)
		es.intValue = swapEndian(es.intValue);

	return es.array;
}

private auto floatEndianImpl(size_t n, bool swap)(ubyte[n] val) @safe pure nothrow @nogc 
		if (n == 4 || n == 8)
{
	static if (n == 4)
		EndianSwapper!float es = void;
	else static if (n == 8)
		EndianSwapper!double es = void;

	es.array = val;

	static if (swap)
		es.intValue = swapEndian(es.intValue);

	return es.value;
}

private template isFloatOrDouble(T)
{
	enum isFloatOrDouble = isFloatingPoint!T && !is(Unqual!(FloatingPointTypeOf!T) == real);
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(float, double))
	{
		static assert(isFloatOrDouble!(T));
		static assert(isFloatOrDouble!(const T));
		static assert(isFloatOrDouble!(immutable T));
		static assert(isFloatOrDouble!(shared T));
		static assert(isFloatOrDouble!(shared(const T)));
		static assert(isFloatOrDouble!(shared(immutable T)));
	}

	static assert(!isFloatOrDouble!(real));
	static assert(!isFloatOrDouble!(const real));
	static assert(!isFloatOrDouble!(immutable real));
	static assert(!isFloatOrDouble!(shared real));
	static assert(!isFloatOrDouble!(shared(const real)));
	static assert(!isFloatOrDouble!(shared(immutable real)));
}

private template canSwapEndianness(T)
{
	enum canSwapEndianness = isIntegral!T || isSomeChar!T || isBoolean!T || isFloatOrDouble!T;
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(bool, ubyte, byte, ushort, short, uint, int, ulong,
			long, char, wchar, dchar, float, double))
	{
		static assert(canSwapEndianness!(T));
		static assert(canSwapEndianness!(const T));
		static assert(canSwapEndianness!(immutable T));
		static assert(canSwapEndianness!(shared(T)));
		static assert(canSwapEndianness!(shared(const T)));
		static assert(canSwapEndianness!(shared(immutable T)));
	}

	//!
	foreach (T; AliasSeq!(real, string, wstring, dstring))
	{
		static assert(!canSwapEndianness!(T));
		static assert(!canSwapEndianness!(const T));
		static assert(!canSwapEndianness!(immutable T));
		static assert(!canSwapEndianness!(shared(T)));
		static assert(!canSwapEndianness!(shared(const T)));
		static assert(!canSwapEndianness!(shared(immutable T)));
	}
}

/++
    Takes a range of $(D ubyte)s and converts the first $(D T.sizeof) bytes to
    $(D T). The value returned is converted from the given endianness to the
    native endianness. The range is not consumed.

    Params:
        T     = The integral type to convert the first $(D T.sizeof) bytes to.
        endianness = The endianness that the bytes are assumed to be in.
        range = The range to read from.
        index = The index to start reading from (instead of starting at the
                front). If index is a pointer, then it is updated to the index
                after the bytes read. The overloads with index are only
                available if $(D hasSlicing!R) is $(D true).
  +/

T peek(T, Endian endianness = Endian.bigEndian, R)(R range)
		if (canSwapEndianness!T && isForwardRange!R && is(ElementType!R : const ubyte))
{
	static if (hasSlicing!R)
		const ubyte[T.sizeof] bytes = range[0 .. T.sizeof];
	else
	{
		ubyte[T.sizeof] bytes;
		//Make sure that range is not consumed, even if it's a class.
		range = range.save;

		foreach (ref e; bytes)
		{
			e = range.front;
			range.popFront();
		}
	}

	static if (endianness == Endian.bigEndian)
		return bigEndianToNative!T(bytes);
	else
		return littleEndianToNative!T(bytes);
}

/++ Ditto +/
T peek(T, Endian endianness = Endian.bigEndian, R)(R range, size_t index)
		if (canSwapEndianness!T && isForwardRange!R && hasSlicing!R
			&& is(ElementType!R : const ubyte))
{
	return peek!(T, endianness)(range, &index);
}

/++ Ditto +/
T peek(T, Endian endianness = Endian.bigEndian, R)(R range, size_t* index)
		if (canSwapEndianness!T && isForwardRange!R && hasSlicing!R
			&& is(ElementType!R : const ubyte))
{
	assert(index);

	immutable begin = *index;
	immutable end = begin + T.sizeof;
	const ubyte[T.sizeof] bytes = range[begin .. end];
	*index = end;

	static if (endianness == Endian.bigEndian)
		return bigEndianToNative!T(bytes);
	else
		return littleEndianToNative!T(bytes);
}

///
unittest
{
	ubyte[] buffer = [1, 5, 22, 9, 44, 255, 8];
	assert(buffer.peek!uint() == 17110537);
	assert(buffer.peek!ushort() == 261);
	assert(buffer.peek!ubyte() == 1);

	assert(buffer.peek!uint(2) == 369700095);
	assert(buffer.peek!ushort(2) == 5641);
	assert(buffer.peek!ubyte(2) == 22);

	size_t index = 0;
	assert(buffer.peek!ushort(&index) == 261);
	assert(index == 2);

	assert(buffer.peek!uint(&index) == 369700095);
	assert(index == 6);

	assert(buffer.peek!ubyte(&index) == 8);
	assert(index == 7);
}

unittest
{
	{
		//bool
		ubyte[] buffer = [0, 1];
		assert(buffer.peek!bool() == false);
		assert(buffer.peek!bool(1) == true);

		size_t index = 0;
		assert(buffer.peek!bool(&index) == false);
		assert(index == 1);

		assert(buffer.peek!bool(&index) == true);
		assert(index == 2);
	}

	{
		//char (8bit)
		ubyte[] buffer = [97, 98, 99, 100];
		assert(buffer.peek!char() == 'a');
		assert(buffer.peek!char(1) == 'b');

		size_t index = 0;
		assert(buffer.peek!char(&index) == 'a');
		assert(index == 1);

		assert(buffer.peek!char(&index) == 'b');
		assert(index == 2);
	}

	{
		//wchar (16bit - 2x ubyte)
		ubyte[] buffer = [1, 5, 32, 29, 1, 7];
		assert(buffer.peek!wchar() == 'ą');
		assert(buffer.peek!wchar(2) == '”');
		assert(buffer.peek!wchar(4) == 'ć');

		size_t index = 0;
		assert(buffer.peek!wchar(&index) == 'ą');
		assert(index == 2);

		assert(buffer.peek!wchar(&index) == '”');
		assert(index == 4);

		assert(buffer.peek!wchar(&index) == 'ć');
		assert(index == 6);
	}

	{
		//dchar (32bit - 4x ubyte)
		ubyte[] buffer = [0, 0, 1, 5, 0, 0, 32, 29, 0, 0, 1, 7];
		assert(buffer.peek!dchar() == 'ą');
		assert(buffer.peek!dchar(4) == '”');
		assert(buffer.peek!dchar(8) == 'ć');

		size_t index = 0;
		assert(buffer.peek!dchar(&index) == 'ą');
		assert(index == 4);

		assert(buffer.peek!dchar(&index) == '”');
		assert(index == 8);

		assert(buffer.peek!dchar(&index) == 'ć');
		assert(index == 12);
	}

	{
		//float (32bit - 4x ubyte)
		ubyte[] buffer = [66, 0, 0, 0, 65, 200, 0, 0];
		assert(buffer.peek!float() == 32.0);
		assert(buffer.peek!float(4) == 25.0f);

		size_t index = 0;
		assert(buffer.peek!float(&index) == 32.0f);
		assert(index == 4);

		assert(buffer.peek!float(&index) == 25.0f);
		assert(index == 8);
	}

	{
		//double (64bit - 8x ubyte)
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];
		assert(buffer.peek!double() == 32.0);
		assert(buffer.peek!double(8) == 25.0);

		size_t index = 0;
		assert(buffer.peek!double(&index) == 32.0);
		assert(index == 8);

		assert(buffer.peek!double(&index) == 25.0);
		assert(index == 16);
	}

	{
		//enum
		ubyte[] buffer = [0, 0, 0, 10, 0, 0, 0, 20, 0, 0, 0, 30];

		enum Foo
		{
			one = 10,
			two = 20,
			three = 30
		}

		assert(buffer.peek!Foo() == Foo.one);
		assert(buffer.peek!Foo(0) == Foo.one);
		assert(buffer.peek!Foo(4) == Foo.two);
		assert(buffer.peek!Foo(8) == Foo.three);

		size_t index = 0;
		assert(buffer.peek!Foo(&index) == Foo.one);
		assert(index == 4);

		assert(buffer.peek!Foo(&index) == Foo.two);
		assert(index == 8);

		assert(buffer.peek!Foo(&index) == Foo.three);
		assert(index == 12);
	}

	{
		//enum - bool
		ubyte[] buffer = [0, 1];

		enum Bool : bool
		{
			bfalse = false,
			btrue = true,
		}

		assert(buffer.peek!Bool() == Bool.bfalse);
		assert(buffer.peek!Bool(0) == Bool.bfalse);
		assert(buffer.peek!Bool(1) == Bool.btrue);

		size_t index = 0;
		assert(buffer.peek!Bool(&index) == Bool.bfalse);
		assert(index == 1);

		assert(buffer.peek!Bool(&index) == Bool.btrue);
		assert(index == 2);
	}

	{
		//enum - float
		ubyte[] buffer = [66, 0, 0, 0, 65, 200, 0, 0];

		enum Float : float
		{
			one = 32.0f,
			two = 25.0f
		}

		assert(buffer.peek!Float() == Float.one);
		assert(buffer.peek!Float(0) == Float.one);
		assert(buffer.peek!Float(4) == Float.two);

		size_t index = 0;
		assert(buffer.peek!Float(&index) == Float.one);
		assert(index == 4);

		assert(buffer.peek!Float(&index) == Float.two);
		assert(index == 8);
	}

	{
		//enum - double
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];

		enum Double : double
		{
			one = 32.0,
			two = 25.0
		}

		assert(buffer.peek!Double() == Double.one);
		assert(buffer.peek!Double(0) == Double.one);
		assert(buffer.peek!Double(8) == Double.two);

		size_t index = 0;
		assert(buffer.peek!Double(&index) == Double.one);
		assert(index == 8);

		assert(buffer.peek!Double(&index) == Double.two);
		assert(index == 16);
	}

	{
		//enum - real
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];

		enum Real : real
		{
			one = 32.0,
			two = 25.0
		}

		static assert(!__traits(compiles, buffer.peek!Real()));
	}
}

unittest
{
	import std.algorithm;

	ubyte[] buffer = [1, 5, 22, 9, 44, 255, 7];
	auto range = filter!"true"(buffer);
	assert(range.peek!uint() == 17110537);
	assert(range.peek!ushort() == 261);
	assert(range.peek!ubyte() == 1);
}

/++
    Takes a range of $(D ubyte)s and converts the first $(D T.sizeof) bytes to
    $(D T). The value returned is converted from the given endianness to the
    native endianness. The $(D T.sizeof) bytes which are read are consumed from
    the range.

    Params:
        T     = The integral type to convert the first $(D T.sizeof) bytes to.
        endianness = The endianness that the bytes are assumed to be in.
        range = The range to read from.
  +/
T read(T, Endian endianness = Endian.bigEndian, R)(ref R range)
		if (canSwapEndianness!T && isInputRange!R && is(ElementType!R : const ubyte))
{
	static if (hasSlicing!R)
	{
		const ubyte[T.sizeof] bytes = range[0 .. T.sizeof];
		range.popFrontN(T.sizeof);
	}
	else
	{
		ubyte[T.sizeof] bytes;

		foreach (ref e; bytes)
		{
			e = range.front;
			range.popFront();
		}
	}

	static if (endianness == Endian.bigEndian)
		return bigEndianToNative!T(bytes);
	else
		return littleEndianToNative!T(bytes);
}

///
unittest
{
	ubyte[] buffer = [1, 5, 22, 9, 44, 255, 8];
	assert(buffer.length == 7);

	assert(buffer.read!ushort() == 261);
	assert(buffer.length == 5);

	assert(buffer.read!uint() == 369700095);
	assert(buffer.length == 1);

	assert(buffer.read!ubyte() == 8);
	assert(buffer.empty);
}

unittest
{
	{
		//bool
		ubyte[] buffer = [0, 1];
		assert(buffer.length == 2);

		assert(buffer.read!bool() == false);
		assert(buffer.length == 1);

		assert(buffer.read!bool() == true);
		assert(buffer.empty);
	}

	{
		//char (8bit)
		ubyte[] buffer = [97, 98, 99];
		assert(buffer.length == 3);

		assert(buffer.read!char() == 'a');
		assert(buffer.length == 2);

		assert(buffer.read!char() == 'b');
		assert(buffer.length == 1);

		assert(buffer.read!char() == 'c');
		assert(buffer.empty);
	}

	{
		//wchar (16bit - 2x ubyte)
		ubyte[] buffer = [1, 5, 32, 29, 1, 7];
		assert(buffer.length == 6);

		assert(buffer.read!wchar() == 'ą');
		assert(buffer.length == 4);

		assert(buffer.read!wchar() == '”');
		assert(buffer.length == 2);

		assert(buffer.read!wchar() == 'ć');
		assert(buffer.empty);
	}

	{
		//dchar (32bit - 4x ubyte)
		ubyte[] buffer = [0, 0, 1, 5, 0, 0, 32, 29, 0, 0, 1, 7];
		assert(buffer.length == 12);

		assert(buffer.read!dchar() == 'ą');
		assert(buffer.length == 8);

		assert(buffer.read!dchar() == '”');
		assert(buffer.length == 4);

		assert(buffer.read!dchar() == 'ć');
		assert(buffer.empty);
	}

	{
		//float (32bit - 4x ubyte)
		ubyte[] buffer = [66, 0, 0, 0, 65, 200, 0, 0];
		assert(buffer.length == 8);

		assert(buffer.read!float() == 32.0);
		assert(buffer.length == 4);

		assert(buffer.read!float() == 25.0f);
		assert(buffer.empty);
	}

	{
		//double (64bit - 8x ubyte)
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];
		assert(buffer.length == 16);

		assert(buffer.read!double() == 32.0);
		assert(buffer.length == 8);

		assert(buffer.read!double() == 25.0);
		assert(buffer.empty);
	}

	{
		//enum - uint
		ubyte[] buffer = [0, 0, 0, 10, 0, 0, 0, 20, 0, 0, 0, 30];
		assert(buffer.length == 12);

		enum Foo
		{
			one = 10,
			two = 20,
			three = 30
		}

		assert(buffer.read!Foo() == Foo.one);
		assert(buffer.length == 8);

		assert(buffer.read!Foo() == Foo.two);
		assert(buffer.length == 4);

		assert(buffer.read!Foo() == Foo.three);
		assert(buffer.empty);
	}

	{
		//enum - bool
		ubyte[] buffer = [0, 1];
		assert(buffer.length == 2);

		enum Bool : bool
		{
			bfalse = false,
			btrue = true,
		}

		assert(buffer.read!Bool() == Bool.bfalse);
		assert(buffer.length == 1);

		assert(buffer.read!Bool() == Bool.btrue);
		assert(buffer.empty);
	}

	{
		//enum - float
		ubyte[] buffer = [66, 0, 0, 0, 65, 200, 0, 0];
		assert(buffer.length == 8);

		enum Float : float
		{
			one = 32.0f,
			two = 25.0f
		}

		assert(buffer.read!Float() == Float.one);
		assert(buffer.length == 4);

		assert(buffer.read!Float() == Float.two);
		assert(buffer.empty);
	}

	{
		//enum - double
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];
		assert(buffer.length == 16);

		enum Double : double
		{
			one = 32.0,
			two = 25.0
		}

		assert(buffer.read!Double() == Double.one);
		assert(buffer.length == 8);

		assert(buffer.read!Double() == Double.two);
		assert(buffer.empty);
	}

	{
		//enum - real
		ubyte[] buffer = [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0];

		enum Real : real
		{
			one = 32.0,
			two = 25.0
		}

		static assert(!__traits(compiles, buffer.read!Real()));
	}
}

unittest
{
	import std.algorithm;

	ubyte[] buffer = [1, 5, 22, 9, 44, 255, 8];
	auto range = filter!"true"(buffer);
	assert(walkLength(range) == 7);

	assert(range.read!ushort() == 261);
	assert(walkLength(range) == 5);

	assert(range.read!uint() == 369700095);
	assert(walkLength(range) == 1);

	assert(range.read!ubyte() == 8);
	assert(range.empty);
}

/++
    Takes an integral value, converts it to the given endianness, and writes it
    to the given range of $(D ubyte)s as a sequence of $(D T.sizeof) $(D ubyte)s
    starting at index. $(D hasSlicing!R) must be $(D true).

    Params:
        T     = The integral type to convert the first $(D T.sizeof) bytes to.
        endianness = The endianness to _write the bytes in.
        range = The range to _write to.
        value = The value to _write.
        index = The index to start writing to. If index is a pointer, then it
                is updated to the index after the bytes read.
  +/
void write(T, Endian endianness = Endian.bigEndian, R)(R range, T value, size_t index)
		if (canSwapEndianness!T && isForwardRange!R && hasSlicing!R && is(ElementType!R : ubyte))
{
	write!(T, endianness)(range, value, &index);
}

/++ Ditto +/
void write(T, Endian endianness = Endian.bigEndian, R)(R range, T value, size_t* index)
		if (canSwapEndianness!T && isForwardRange!R && hasSlicing!R && is(ElementType!R : ubyte))
{
	assert(index);

	static if (endianness == Endian.bigEndian)
		immutable bytes = nativeToBigEndian!T(value);
	else
		immutable bytes = nativeToLittleEndian!T(value);

	immutable begin = *index;
	immutable end = begin + T.sizeof;
	*index = end;
	range[begin .. end] = bytes[0 .. T.sizeof];
}

///
unittest
{
	{
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0];
		buffer.write!uint(29110231u, 0);
		assert(buffer == [1, 188, 47, 215, 0, 0, 0, 0]);

		buffer.write!ushort(927, 0);
		assert(buffer == [3, 159, 47, 215, 0, 0, 0, 0]);

		buffer.write!ubyte(42, 0);
		assert(buffer == [42, 159, 47, 215, 0, 0, 0, 0]);
	}

	{
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		buffer.write!uint(142700095u, 2);
		assert(buffer == [0, 0, 8, 129, 110, 63, 0, 0, 0]);

		buffer.write!ushort(19839, 2);
		assert(buffer == [0, 0, 77, 127, 110, 63, 0, 0, 0]);

		buffer.write!ubyte(132, 2);
		assert(buffer == [0, 0, 132, 127, 110, 63, 0, 0, 0]);
	}

	{
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0];
		size_t index = 0;
		buffer.write!ushort(261, &index);
		assert(buffer == [1, 5, 0, 0, 0, 0, 0, 0]);
		assert(index == 2);

		buffer.write!uint(369700095u, &index);
		assert(buffer == [1, 5, 22, 9, 44, 255, 0, 0]);
		assert(index == 6);

		buffer.write!ubyte(8, &index);
		assert(buffer == [1, 5, 22, 9, 44, 255, 8, 0]);
		assert(index == 7);
	}
}

unittest
{
	{
		//bool
		ubyte[] buffer = [0, 0];

		buffer.write!bool(false, 0);
		assert(buffer == [0, 0]);

		buffer.write!bool(true, 0);
		assert(buffer == [1, 0]);

		buffer.write!bool(true, 1);
		assert(buffer == [1, 1]);

		buffer.write!bool(false, 1);
		assert(buffer == [1, 0]);

		size_t index = 0;
		buffer.write!bool(false, &index);
		assert(buffer == [0, 0]);
		assert(index == 1);

		buffer.write!bool(true, &index);
		assert(buffer == [0, 1]);
		assert(index == 2);
	}

	{
		//char (8bit)
		ubyte[] buffer = [0, 0, 0];

		buffer.write!char('a', 0);
		assert(buffer == [97, 0, 0]);

		buffer.write!char('b', 1);
		assert(buffer == [97, 98, 0]);

		size_t index = 0;
		buffer.write!char('a', &index);
		assert(buffer == [97, 98, 0]);
		assert(index == 1);

		buffer.write!char('b', &index);
		assert(buffer == [97, 98, 0]);
		assert(index == 2);

		buffer.write!char('c', &index);
		assert(buffer == [97, 98, 99]);
		assert(index == 3);
	}

	{
		//wchar (16bit - 2x ubyte)
		ubyte[] buffer = [0, 0, 0, 0];

		buffer.write!wchar('ą', 0);
		assert(buffer == [1, 5, 0, 0]);

		buffer.write!wchar('”', 2);
		assert(buffer == [1, 5, 32, 29]);

		size_t index = 0;
		buffer.write!wchar('ć', &index);
		assert(buffer == [1, 7, 32, 29]);
		assert(index == 2);

		buffer.write!wchar('ą', &index);
		assert(buffer == [1, 7, 1, 5]);
		assert(index == 4);
	}

	{
		//dchar (32bit - 4x ubyte)
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0];

		buffer.write!dchar('ą', 0);
		assert(buffer == [0, 0, 1, 5, 0, 0, 0, 0]);

		buffer.write!dchar('”', 4);
		assert(buffer == [0, 0, 1, 5, 0, 0, 32, 29]);

		size_t index = 0;
		buffer.write!dchar('ć', &index);
		assert(buffer == [0, 0, 1, 7, 0, 0, 32, 29]);
		assert(index == 4);

		buffer.write!dchar('ą', &index);
		assert(buffer == [0, 0, 1, 7, 0, 0, 1, 5]);
		assert(index == 8);
	}

	{
		//float (32bit - 4x ubyte)
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0];

		buffer.write!float(32.0f, 0);
		assert(buffer == [66, 0, 0, 0, 0, 0, 0, 0]);

		buffer.write!float(25.0f, 4);
		assert(buffer == [66, 0, 0, 0, 65, 200, 0, 0]);

		size_t index = 0;
		buffer.write!float(25.0f, &index);
		assert(buffer == [65, 200, 0, 0, 65, 200, 0, 0]);
		assert(index == 4);

		buffer.write!float(32.0f, &index);
		assert(buffer == [65, 200, 0, 0, 66, 0, 0, 0]);
		assert(index == 8);
	}

	{
		//double (64bit - 8x ubyte)
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		buffer.write!double(32.0, 0);
		assert(buffer == [64, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

		buffer.write!double(25.0, 8);
		assert(buffer == [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0]);

		size_t index = 0;
		buffer.write!double(25.0, &index);
		assert(buffer == [64, 57, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0]);
		assert(index == 8);

		buffer.write!double(32.0, &index);
		assert(buffer == [64, 57, 0, 0, 0, 0, 0, 0, 64, 64, 0, 0, 0, 0, 0, 0]);
		assert(index == 16);
	}

	{
		//enum
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		enum Foo
		{
			one = 10,
			two = 20,
			three = 30
		}

		buffer.write!Foo(Foo.one, 0);
		assert(buffer == [0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0]);

		buffer.write!Foo(Foo.two, 4);
		assert(buffer == [0, 0, 0, 10, 0, 0, 0, 20, 0, 0, 0, 0]);

		buffer.write!Foo(Foo.three, 8);
		assert(buffer == [0, 0, 0, 10, 0, 0, 0, 20, 0, 0, 0, 30]);

		size_t index = 0;
		buffer.write!Foo(Foo.three, &index);
		assert(buffer == [0, 0, 0, 30, 0, 0, 0, 20, 0, 0, 0, 30]);
		assert(index == 4);

		buffer.write!Foo(Foo.one, &index);
		assert(buffer == [0, 0, 0, 30, 0, 0, 0, 10, 0, 0, 0, 30]);
		assert(index == 8);

		buffer.write!Foo(Foo.two, &index);
		assert(buffer == [0, 0, 0, 30, 0, 0, 0, 10, 0, 0, 0, 20]);
		assert(index == 12);
	}

	{
		//enum - bool
		ubyte[] buffer = [0, 0];

		enum Bool : bool
		{
			bfalse = false,
			btrue = true,
		}

		buffer.write!Bool(Bool.btrue, 0);
		assert(buffer == [1, 0]);

		buffer.write!Bool(Bool.btrue, 1);
		assert(buffer == [1, 1]);

		size_t index = 0;
		buffer.write!Bool(Bool.bfalse, &index);
		assert(buffer == [0, 1]);
		assert(index == 1);

		buffer.write!Bool(Bool.bfalse, &index);
		assert(buffer == [0, 0]);
		assert(index == 2);
	}

	{
		//enum - float
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0];

		enum Float : float
		{
			one = 32.0f,
			two = 25.0f
		}

		buffer.write!Float(Float.one, 0);
		assert(buffer == [66, 0, 0, 0, 0, 0, 0, 0]);

		buffer.write!Float(Float.two, 4);
		assert(buffer == [66, 0, 0, 0, 65, 200, 0, 0]);

		size_t index = 0;
		buffer.write!Float(Float.two, &index);
		assert(buffer == [65, 200, 0, 0, 65, 200, 0, 0]);
		assert(index == 4);

		buffer.write!Float(Float.one, &index);
		assert(buffer == [65, 200, 0, 0, 66, 0, 0, 0]);
		assert(index == 8);
	}

	{
		//enum - double
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		enum Double : double
		{
			one = 32.0,
			two = 25.0
		}

		buffer.write!Double(Double.one, 0);
		assert(buffer == [64, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

		buffer.write!Double(Double.two, 8);
		assert(buffer == [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0]);

		size_t index = 0;
		buffer.write!Double(Double.two, &index);
		assert(buffer == [64, 57, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0]);
		assert(index == 8);

		buffer.write!Double(Double.one, &index);
		assert(buffer == [64, 57, 0, 0, 0, 0, 0, 0, 64, 64, 0, 0, 0, 0, 0, 0]);
		assert(index == 16);
	}

	{
		//enum - real
		ubyte[] buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		enum Real : real
		{
			one = 32.0,
			two = 25.0
		}

		static assert(!__traits(compiles, buffer.write!Real(Real.one)));
	}
}

/++
    Takes an integral value, converts it to the given endianness, and appends
    it to the given range of $(D ubyte)s (using $(D put)) as a sequence of
    $(D T.sizeof) $(D ubyte)s starting at index. $(D hasSlicing!R) must be
    $(D true).

    Params:
        T     = The integral type to convert the first $(D T.sizeof) bytes to.
        endianness = The endianness to write the bytes in.
        range = The range to _append to.
        value = The value to _append.
  +/
void append(T, Endian endianness = Endian.bigEndian, R)(R range, T value)
		if (canSwapEndianness!T && isOutputRange!(R, ubyte))
{
	static if (endianness == Endian.bigEndian)
		immutable bytes = nativeToBigEndian!T(value);
	else
		immutable bytes = nativeToLittleEndian!T(value);

	put(range, bytes[]);
}

///
unittest
{
	import std.array;

	auto buffer = appender!(const ubyte[])();
	buffer.append!ushort(261);
	assert(buffer.data == [1, 5]);

	buffer.append!uint(369700095u);
	assert(buffer.data == [1, 5, 22, 9, 44, 255]);

	buffer.append!ubyte(8);
	assert(buffer.data == [1, 5, 22, 9, 44, 255, 8]);
}

unittest
{
	import std.array;
	{
		//bool
		auto buffer = appender!(const ubyte[])();

		buffer.append!bool(true);
		assert(buffer.data == [1]);

		buffer.append!bool(false);
		assert(buffer.data == [1, 0]);
	}

	{
		//char wchar dchar
		auto buffer = appender!(const ubyte[])();

		buffer.append!char('a');
		assert(buffer.data == [97]);

		buffer.append!char('b');
		assert(buffer.data == [97, 98]);

		buffer.append!wchar('ą');
		assert(buffer.data == [97, 98, 1, 5]);

		buffer.append!dchar('ą');
		assert(buffer.data == [97, 98, 1, 5, 0, 0, 1, 5]);
	}

	{
		//float double
		auto buffer = appender!(const ubyte[])();

		buffer.append!float(32.0f);
		assert(buffer.data == [66, 0, 0, 0]);

		buffer.append!double(32.0);
		assert(buffer.data == [66, 0, 0, 0, 64, 64, 0, 0, 0, 0, 0, 0]);
	}

	{
		//enum
		auto buffer = appender!(const ubyte[])();

		enum Foo
		{
			one = 10,
			two = 20,
			three = 30
		}

		buffer.append!Foo(Foo.one);
		assert(buffer.data == [0, 0, 0, 10]);

		buffer.append!Foo(Foo.two);
		assert(buffer.data == [0, 0, 0, 10, 0, 0, 0, 20]);

		buffer.append!Foo(Foo.three);
		assert(buffer.data == [0, 0, 0, 10, 0, 0, 0, 20, 0, 0, 0, 30]);
	}

	{
		//enum - bool
		auto buffer = appender!(const ubyte[])();

		enum Bool : bool
		{
			bfalse = false,
			btrue = true,
		}

		buffer.append!Bool(Bool.btrue);
		assert(buffer.data == [1]);

		buffer.append!Bool(Bool.bfalse);
		assert(buffer.data == [1, 0]);

		buffer.append!Bool(Bool.btrue);
		assert(buffer.data == [1, 0, 1]);
	}

	{
		//enum - float
		auto buffer = appender!(const ubyte[])();

		enum Float : float
		{
			one = 32.0f,
			two = 25.0f
		}

		buffer.append!Float(Float.one);
		assert(buffer.data == [66, 0, 0, 0]);

		buffer.append!Float(Float.two);
		assert(buffer.data == [66, 0, 0, 0, 65, 200, 0, 0]);
	}

	{
		//enum - double
		auto buffer = appender!(const ubyte[])();

		enum Double : double
		{
			one = 32.0,
			two = 25.0
		}

		buffer.append!Double(Double.one);
		assert(buffer.data == [64, 64, 0, 0, 0, 0, 0, 0]);

		buffer.append!Double(Double.two);
		assert(buffer.data == [64, 64, 0, 0, 0, 0, 0, 0, 64, 57, 0, 0, 0, 0, 0, 0]);
	}

	{
		//enum - real
		auto buffer = appender!(const ubyte[])();

		enum Real : real
		{
			one = 32.0,
			two = 25.0
		}

		static assert(!__traits(compiles, buffer.append!Real(Real.one)));
	}
}

unittest
{
	import std.format : format;
	import std.array;
	import std.meta;

	foreach (endianness; AliasSeq!(Endian.bigEndian, Endian.littleEndian))
	{
		auto toWrite = appender!(ubyte[])();
		alias Types = AliasSeq!(uint, int, long, ulong, short, ubyte, ushort, byte, uint);
		ulong[] values = [42, -11, long.max, 1098911981329L, 16, 255, 19012, 2, 17];
		assert(Types.length == values.length);

		size_t index = 0;
		size_t length = 0;
		foreach (T; Types)
		{
			toWrite.append!(T, endianness)(cast(T) values[index++]);
			length += T.sizeof;
		}

		auto toRead = toWrite.data;
		assert(toRead.length == length);

		index = 0;
		foreach (T; Types)
		{
			assert(toRead.peek!(T, endianness)() == values[index],
					format("Failed Index: %s", index));
			assert(toRead.peek!(T, endianness)(0) == values[index],
					format("Failed Index: %s", index));
			assert(toRead.length == length,
					format("Failed Index [%s], Actual Length: %s", index, toRead.length));
			assert(toRead.read!(T, endianness)() == values[index],
					format("Failed Index: %s", index));
			length -= T.sizeof;
			assert(toRead.length == length,
					format("Failed Index [%s], Actual Length: %s", index, toRead.length));
			++index;
		}
		assert(toRead.empty);
	}
}

/**
Counts the number of set bits in the binary representation of $(D value).
For signed integers, the sign bit is included in the count.
*/
private uint countBitsSet(T)(T value) @nogc pure nothrow if (isIntegral!T)
{
	// http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
	static if (T.sizeof == 8)
	{
		T c = value - ((value >> 1) & 0x55555555_55555555);
		c = ((c >> 2) & 0x33333333_33333333) + (c & 0x33333333_33333333);
		c = ((c >> 4) + c) & 0x0F0F0F0F_0F0F0F0F;
		c = ((c >> 8) + c) & 0x00FF00FF_00FF00FF;
		c = ((c >> 16) + c) & 0x0000FFFF_0000FFFF;
		c = ((c >> 32) + c) & 0x00000000_FFFFFFFF;
	}
	else static if (T.sizeof == 4)
	{
		T c = value - ((value >> 1) & 0x55555555);
		c = ((c >> 2) & 0x33333333) + (c & 0x33333333);
		c = ((c >> 4) + c) & 0x0F0F0F0F;
		c = ((c >> 8) + c) & 0x00FF00FF;
		c = ((c >> 16) + c) & 0x0000FFFF;
	}
	else static if (T.sizeof == 2)
	{
		uint c = value - ((value >> 1) & 0x5555);
		c = ((c >> 2) & 0x3333) + (c & 0X3333);
		c = ((c >> 4) + c) & 0x0F0F;
		c = ((c >> 8) + c) & 0x00FF;
	}
	else static if (T.sizeof == 1)
	{
		uint c = value - ((value >> 1) & 0x55);
		c = ((c >> 2) & 0x33) + (c & 0X33);
		c = ((c >> 4) + c) & 0x0F;
	}
	else
	{
		static assert("countBitsSet only supports 1, 2, 4, or 8 byte sized integers.");
	}
	return cast(uint) c;
}

///
unittest
{
	assert(countBitsSet(1) == 1);
	assert(countBitsSet(0) == 0);
	assert(countBitsSet(int.min) == 1);
	assert(countBitsSet(uint.max) == 32);
}

unittest
{
	import std.meta;

	foreach (T; AliasSeq!(byte, ubyte, short, ushort, int, uint, long, ulong))
	{
		assert(countBitsSet(cast(T) 0) == 0);
		assert(countBitsSet(cast(T) 1) == 1);
		assert(countBitsSet(cast(T) 2) == 1);
		assert(countBitsSet(cast(T) 3) == 2);
		assert(countBitsSet(cast(T) 4) == 1);
		assert(countBitsSet(cast(T) 5) == 2);
		assert(countBitsSet(cast(T) 127) == 7);
		static if (isSigned!T)
		{
			assert(countBitsSet(cast(T)-1) == 8 * T.sizeof);
			assert(countBitsSet(T.min) == 1);
		}
		else
		{
			assert(countBitsSet(T.max) == 8 * T.sizeof);
		}
	}
	assert(countBitsSet(1_000_000) == 7);
	foreach (i; 0 .. 63)
		assert(countBitsSet(1UL << i) == 1);
}

private struct BitsSet(T)
{
	static assert(T.sizeof <= 8, "bitsSet assumes T is no more than 64-bit.");

@nogc pure nothrow:

	this(T value, size_t startIndex = 0)
	{
		_value = value;
		// Further calculation is only valid and needed when the range is non-empty.
		if (!_value)
			return;

		import core.bitop : bsf;

		uint trailingZerosCount = bsf(value);
		_value >>>= trailingZerosCount;
		_index = startIndex + trailingZerosCount;
	}

	@property size_t front()
	{
		return _index;
	}

	@property bool empty() const
	{
		return !_value;
	}

	void popFront()
	{
		assert(_value, "Cannot call popFront on empty range.");

		_value >>>= 1;
		// Further calculation is only valid and needed when the range is non-empty.
		if (!_value)
			return;

		import core.bitop : bsf;

		uint trailingZerosCount = bsf(_value);
		_value >>>= trailingZerosCount;
		_index += trailingZerosCount + 1;
	}

	@property auto save()
	{
		return this;
	}

	@property size_t length()
	{
		return countBitsSet(_value);
	}

	private T _value;
	private size_t _index;
}

/**
Range that iterates the indices of the set bits in $(D value).
Index 0 corresponds to the least significant bit.
For signed integers, the highest index corresponds to the sign bit.
*/
auto bitsSet(T)(T value) @nogc pure nothrow if (isIntegral!T)
{
	return BitsSet!T(value);
}

///
unittest
{
	import std.algorithm : equal;
	import std.range : iota;

	assert(bitsSet(1).equal([0]));
	assert(bitsSet(5).equal([0, 2]));
	assert(bitsSet(-1).equal(iota(32)));
	assert(bitsSet(int.min).equal([31]));
}

unittest
{
	import std.algorithm : equal;
	import std.range : iota;

	import std.meta;

	foreach (T; AliasSeq!(byte, ubyte, short, ushort, int, uint, long, ulong))
	{
		assert(bitsSet(cast(T) 0).empty);
		assert(bitsSet(cast(T) 1).equal([0]));
		assert(bitsSet(cast(T) 2).equal([1]));
		assert(bitsSet(cast(T) 3).equal([0, 1]));
		assert(bitsSet(cast(T) 4).equal([2]));
		assert(bitsSet(cast(T) 5).equal([0, 2]));
		assert(bitsSet(cast(T) 127).equal(iota(7)));
		static if (isSigned!T)
		{
			assert(bitsSet(cast(T)-1).equal(iota(8 * T.sizeof)));
			assert(bitsSet(T.min).equal([8 * T.sizeof - 1]));
		}
		else
		{
			assert(bitsSet(T.max).equal(iota(8 * T.sizeof)));
		}
	}
	assert(bitsSet(1_000_000).equal([6, 9, 14, 16, 17, 18, 19]));
	foreach (i; 0 .. 63)
		assert(bitsSet(1UL << i).equal([i]));
}
