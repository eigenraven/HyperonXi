/**
 * Modified to remove system dependance
 */
/**
 * Forms the symbols available to all D programs. Includes Object, which is
 * the root of the class object hierarchy.  This module is implicitly
 * imported.
 * Macros:
 *      WIKI = Object
 *
 * Copyright: Copyright Digital Mars 2000 - 2011.
 * License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Walter Bright, Sean Kelly
 */

/*          Copyright Digital Mars 2000 - 2011.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module object;

mixin(makeTypeInfo!(char, wchar, dchar, int, uint, short, ushort, byte, ubyte,
	long, ulong, float, double, real, void, bool, string)());

private string makeTypeInfo(T...)()
{
	if (__ctfe)
	{
		string code;

		enum doit(t) = "class TypeInfo_" ~ t.mangleof ~ " : TypeInfo {
					override string toString() const { return \"" ~ t
				.stringof ~ "\"; }
				}";
		template doitm(string s, t, u...)
		{
			static if (u.length == 0)
			{
				enum doitm = s ~ doit!(t);
			}
			else
			{
				enum doitm = doitm!(s ~ doit!(t), u);
			}
		}

		return doitm!("", T);
	}

	assert(0);
}

private
{
	extern (C) Object _d_newclass(const TypeInfo_Class ci)
	{
		return null;
	}

	extern (C) void rt_finalize(void* data, bool det = true)
	{
	}

	bool streq(char[] A, char[] B) @nogc nothrow
	{
		if (A.length != B.length)
			return false;
		for (int i = 0; i < A.length; i++)
		{
			if (A[i] != B[i])
				return false;
		}
		return true;
	}

extern (C):
@system:
nothrow:
@nogc:
	pure int memcmp(in void* s1, in void* s2, size_t n);
	pure void* memcpy(void* s1, in void* s2, size_t n);
	pure size_t strlen(in char* s);
	void _d_dso_registry(void* dt)
	{
	}

	void _d_unittestm(string file, uint line)
	{
	}

	void _d_array_bounds(void* m, uint line)
	{
	}

	void _d_arraybounds(string m, uint line)
	{
	}

	void _d_unittest()
	{
	}

	void _d_assertm(void* m, uint line)
	{
	}

	void _d_assert(string file, uint line)
	{
	}

	void _d_assert_msg(string msg, string file, uint line)
	{
	}

	Object _d_dynamic_cast(Object o, ClassInfo c)
	{
		return null;
	}

	int _adEq2(byte[] a1, byte[] a2, TypeInfo ti)
	{
		if (a1.length != a2.length)
			return 0;
		for (int a = 0; a < a1.length; a++)
			if (a1[a] != a2[a])
				return 0;
		return 1;
	}

	ptrdiff_t _d_switch_string(char[][] table, char[] it)
	{
		foreach (i, item; table)
			if (streq(item, it))
				return i;
		return -1;
	}

	byte[] _d_arraycopy(size_t size, byte[] from, byte[] to)
	{
		if (to.length != from.length)
		{
			return to;
		}
		else if (to.ptr + to.length * size <= from.ptr || from.ptr + from.length * size <= to.ptr)
		{
			memcpy(to.ptr, from.ptr, to.length * size);
		}
		else
		{
			return to;
		}
		return to;
	}
}

// NOTE: For some reason, this declaration method doesn't work
//       in this particular file (and this file only).  It must
//       be a DMD thing.
//alias typeof(int.sizeof)                    size_t;
//alias typeof(cast(void*)0 - cast(void*)0)   ptrdiff_t;

version (D_LP64)
{
	alias ulong size_t;
	alias long ptrdiff_t;
}
else
{
	alias uint size_t;
	alias int ptrdiff_t;
}

alias ptrdiff_t sizediff_t; //For backwards compatibility only.

alias size_t hash_t; //For backwards compatibility only.
alias bool equals_t; //For backwards compatibility only.

alias immutable(char)[] string;
alias immutable(wchar)[] wstring;
alias immutable(dchar)[] dstring;

version (LDC) version (X86_64)
{
	// Layout of this struct must match __gnuc_va_list for C ABI compatibility.
	// Defined here for LDC as it is referenced from implicitly generated code
	// for D-style variadics, etc., and we do not require people to manually
	// import core.vararg like DMD does.
	struct __va_list_tag
	{
		uint offset_regs = 6 * 8;
		uint offset_fpregs = 6 * 8 + 8 * 16;
		void* stack_args;
		void* reg_args;
	}
}

/**
 * All D class objects inherit from Object.
 */
class Object
{
	/**
     * Convert Object to a human readable string.
     */
	string toString()
	{
		return "";
	}

	/**
     * Compute hash function for Object.
     */
	size_t toHash() @trusted nothrow
	{
		// BUG: this prevents a compacting GC from working, needs to be fixed
		return cast(size_t) cast(void*) this;
	}

	/**
     * Compare with another Object obj.
     * Returns:
     *  $(TABLE
     *  $(TR $(TD this &lt; obj) $(TD &lt; 0))
     *  $(TR $(TD this == obj) $(TD 0))
     *  $(TR $(TD this &gt; obj) $(TD &gt; 0))
     *  )
     */
	int opCmp(Object o)
	{
		return this !is o;
	}

	/**
     * Returns !=0 if this object does have the same contents as obj.
     */
	bool opEquals(Object o)
	{
		return this is o;
	}

	interface Monitor
	{
		void lock();
		void unlock();
	}

	/**
     * Create instance of class specified by the fully qualified name
     * classname.
     * The class must either have no constructors or have
     * a default constructor.
     * Returns:
     *   null if failed
     * Example:
     * ---
     * module foo.bar;
     *
     * class C
     * {
     *     this() { x = 10; }
     *     int x;
     * }
     *
     * void main()
     * {
     *     auto c = cast(C)Object.factory("foo.bar.C");
     *     assert(c !is null && c.x == 10);
     * }
     * ---
     */
	static Object factory(string classname)
	{
		return null;
	}
}

auto opEquals(Object lhs, Object rhs)
{
	// If aliased to the same object or both null => equal
	if (lhs is rhs)
		return true;

	// If either is null => non-equal
	if (lhs is null || rhs is null)
		return false;

	// General case => symmetric calls to method opEquals
	return lhs.opEquals(rhs) && rhs.opEquals(lhs);
}

/************************
* Returns true if lhs and rhs are equal.
*/
auto opEquals(const Object lhs, const Object rhs)
{
	// A hack for the moment.
	return opEquals(cast() lhs, cast() rhs);
}

private extern (C) void _d_setSameMutex(shared Object ownee, shared Object owner) nothrow
{
}

void setSameMutex(shared Object ownee, shared Object owner)
{
	_d_setSameMutex(ownee, owner);
}

/**
 * Information about an interface.
 * When an object is accessed via an interface, an Interface* appears as the
 * first entry in its vtbl.
 */
struct Interface
{
	TypeInfo_Class classinfo; /// .classinfo for this interface (not for containing class)
	void*[] vtbl;
	size_t offset; /// offset to Interface 'this' from Object 'this'
}

/**
 * Array of pairs giving the offset and type information for each
 * member in an aggregate.
 */
struct OffsetTypeInfo
{
	size_t offset; /// Offset of member from start of object
	TypeInfo ti; /// TypeInfo for this member
}

/**
 * Runtime type information about a type.
 * Can be retrieved for any type using a
 * <a href="../expression.html#typeidexpression">TypeidExpression</a>.
 */
class TypeInfo
{
	override string toString() const pure @safe nothrow
	{
		return "";
	}

	override size_t toHash() @trusted const
	{
		return cast(size_t) cast(void*) this;
	}

	override int opCmp(Object o)
	{
		return this is typeid(o);
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	/// Returns a hash of the instance of a type.
	size_t getHash(in void* p) @trusted nothrow const
	{
		return cast(size_t) p;
	}

	/// Compares two instances for equality.
	bool equals(in void* p1, in void* p2) const
	{
		return p1 == p2;
	}

	/// Compares two instances for &lt;, ==, or &gt;.
	int compare(in void* p1, in void* p2) const
	{
		return _xopCmp(p1, p2);
	}

	/// Returns size of the type.
	@property size_t tsize() nothrow pure const @safe @nogc
	{
		return 0;
	}

	/// Swaps two instances of the type.
	void swap(void* p1, void* p2) const
	{
		size_t n = tsize;
		for (size_t i = 0; i < n; i++)
		{
			byte t = (cast(byte*) p1)[i];
			(cast(byte*) p1)[i] = (cast(byte*) p2)[i];
			(cast(byte*) p2)[i] = t;
		}
	}

	/// Get TypeInfo for 'next' type, as defined by what kind of type this is,
	/// null if none.
	@property inout(TypeInfo) next() nothrow pure inout @nogc
	{
		return null;
	}

	/// Return default initializer.  If the type should be initialized to all zeros,
	/// an array with a null ptr and a length equal to the type size will be returned.
	version (LDC)
	{
		// LDC uses TypeInfo's vtable for the typeof(null) type:
		//   %"typeid(typeof(null))" = type { %object.TypeInfo.__vtbl*, i8* }
		// Therefore this class cannot be abstract, and all methods need implementations.
		// Tested by test14754() in runnable/inline.d, and a unittest below.
		const(void)[] init() nothrow pure const @safe @nogc
		{
			return null;
		}
	}
	else
	{
		abstract const(void)[] init() nothrow pure const @safe @nogc;
	}

	/// Get flags for type: 1 means GC should scan for pointers,
	/// 2 means arg of this type is passed in XMM register
	@property uint flags() nothrow pure const @safe @nogc
	{
		return 0;
	}

	/// Get type information on the contents of the type; null if not available
	const(OffsetTypeInfo)[] offTi() const
	{
		return null;
	}
	/// Run the destructor on the object and all its sub-objects
	void destroy(void* p) const
	{
	}
	/// Run the postblit on the object and all its sub-objects
	void postblit(void* p) const
	{
	}

	/// Return alignment of type
	@property size_t talign() nothrow pure const @safe @nogc
	{
		return tsize;
	}

	/** Return internal info on arguments fitting into 8byte.
     * See X86-64 ABI 3.2.3
     */
	version (X86_64) int argTypes(out TypeInfo arg1, out TypeInfo arg2) @safe nothrow
	{
		arg1 = this;
		return 0;
	}

	/** Return info used by the garbage collector to do precise collection.
     */
	@property immutable(void)* rtInfo() nothrow pure const @safe @nogc
	{
		return null;
	}
}

class TypeInfo_Typedef : TypeInfo
{
	override string toString() const
	{
		return name;
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) const
	{
		return base.getHash(p);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		return base.equals(p1, p2);
	}

	override int compare(in void* p1, in void* p2) const
	{
		return base.compare(p1, p2);
	}

	override @property size_t tsize() nothrow pure const
	{
		return base.tsize;
	}

	override void swap(void* p1, void* p2) const
	{
		return base.swap(p1, p2);
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return base.next;
	}

	override @property uint flags() nothrow pure const
	{
		return base.flags;
	}

	override const(void)[] init() const
	{
		return m_init.length ? m_init : base.init();
	}

	override @property size_t talign() nothrow pure const
	{
		return base.talign;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		return base.argTypes(arg1, arg2);
	}

	override @property immutable(void)* rtInfo() const
	{
		return base.rtInfo;
	}

	TypeInfo base;
	string name;
	void[] m_init;
}

class TypeInfo_Enum : TypeInfo_Typedef
{

}

// Please make sure to keep this in sync with TypeInfo_P (src/rt/typeinfo/ti_ptr.d)
class TypeInfo_Pointer : TypeInfo
{
	override string toString() const
	{
		return "PTR*";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @trusted const
	{
		return cast(size_t)*cast(void**) p;
	}

	override bool equals(in void* p1, in void* p2) const
	{
		return *cast(void**) p1 == *cast(void**) p2;
	}

	override int compare(in void* p1, in void* p2) const
	{
		if (*cast(void**) p1 < *cast(void**) p2)
			return -1;
		else if (*cast(void**) p1 > *cast(void**) p2)
			return 1;
		else
			return 0;
	}

	override @property size_t tsize() nothrow pure const
	{
		return (void*).sizeof;
	}

	override const(void)[] init() const @trusted
	{
		return (cast(void*) null)[0 .. (void*).sizeof];
	}

	override void swap(void* p1, void* p2) const
	{
		void* tmp = *cast(void**) p1;
		*cast(void**) p1 = *cast(void**) p2;
		*cast(void**) p2 = tmp;
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return m_next;
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	TypeInfo m_next;
}

class TypeInfo_Array : TypeInfo
{
	override string toString() const
	{
		return "ARR[]";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @trusted const
	{
		void[] a = *cast(void[]*) p;
		return getArrayHash(value, a.ptr, a.length);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		void[] a1 = *cast(void[]*) p1;
		void[] a2 = *cast(void[]*) p2;
		if (a1.length != a2.length)
			return false;
		size_t sz = value.tsize;
		for (size_t i = 0; i < a1.length; i++)
		{
			if (!value.equals(a1.ptr + i * sz, a2.ptr + i * sz))
				return false;
		}
		return true;
	}

	override int compare(in void* p1, in void* p2) const
	{
		void[] a1 = *cast(void[]*) p1;
		void[] a2 = *cast(void[]*) p2;
		size_t sz = value.tsize;
		size_t len = a1.length;

		if (a2.length < len)
			len = a2.length;
		for (size_t u = 0; u < len; u++)
		{
			int result = value.compare(a1.ptr + u * sz, a2.ptr + u * sz);
			if (result)
				return result;
		}
		return cast(int) a1.length - cast(int) a2.length;
	}

	override @property size_t tsize() nothrow pure const
	{
		return (void[]).sizeof;
	}

	override const(void)[] init() const @trusted
	{
		return (cast(void*) null)[0 .. (void[]).sizeof];
	}

	override void swap(void* p1, void* p2) const
	{
		void[] tmp = *cast(void[]*) p1;
		*cast(void[]*) p1 = *cast(void[]*) p2;
		*cast(void[]*) p2 = tmp;
	}

	TypeInfo value;

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return value;
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	override @property size_t talign() nothrow pure const
	{
		return (void[]).alignof;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		arg1 = typeid(size_t);
		arg2 = typeid(void*);
		return 0;
	}
}

class TypeInfo_StaticArray : TypeInfo
{
	override string toString() const
	{
		return "[STATIC_ARRAY]";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @trusted const
	{
		return getArrayHash(value, p, len);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		size_t sz = value.tsize;

		for (size_t u = 0; u < len; u++)
		{
			if (!value.equals(p1 + u * sz, p2 + u * sz))
				return false;
		}
		return true;
	}

	override int compare(in void* p1, in void* p2) const
	{
		size_t sz = value.tsize;

		for (size_t u = 0; u < len; u++)
		{
			int result = value.compare(p1 + u * sz, p2 + u * sz);
			if (result)
				return result;
		}
		return 0;
	}

	override @property size_t tsize() nothrow pure const
	{
		return len * value.tsize;
	}

	override void swap(void* p1, void* p2) const
	{

	}

	override const(void)[] init() nothrow pure const
	{
		return value.init();
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return value;
	}

	override @property uint flags() nothrow pure const
	{
		return value.flags;
	}

	override void destroy(void* p) const
	{
		auto sz = value.tsize;
		p += sz * len;
		foreach (i; 0 .. len)
		{
			p -= sz;
			value.destroy(p);
		}
	}

	override void postblit(void* p) const
	{
		auto sz = value.tsize;
		foreach (i; 0 .. len)
		{
			value.postblit(p);
			p += sz;
		}
	}

	TypeInfo value;
	size_t len;

	override @property size_t talign() nothrow pure const
	{
		return value.talign;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		arg1 = typeid(void*);
		return 0;
	}
}

class TypeInfo_AssociativeArray : TypeInfo
{
	override string toString() const
	{
		return "AA[AA]";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override bool equals(in void* p1, in void* p2) @trusted const
	{
		return p1 is p2;
	}

	override hash_t getHash(in void* p) nothrow @trusted const
	{
		return cast(hash_t) p;
	}

	// BUG: need to add the rest of the functions

	override @property size_t tsize() nothrow pure const
	{
		return (char[int]).sizeof;
	}

	override const(void)[] init() const @trusted
	{
		return (cast(void*) null)[0 .. (char[int]).sizeof];
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return value;
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	TypeInfo value;
	TypeInfo key;

	override @property size_t talign() nothrow pure const
	{
		return (char[int]).alignof;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		arg1 = typeid(void*);
		return 0;
	}
}

class TypeInfo_Vector : TypeInfo
{
	override string toString() const
	{
		return "__vector(...)";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) const
	{
		return base.getHash(p);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		return base.equals(p1, p2);
	}

	override int compare(in void* p1, in void* p2) const
	{
		return base.compare(p1, p2);
	}

	override @property size_t tsize() nothrow pure const
	{
		return base.tsize;
	}

	override void swap(void* p1, void* p2) const
	{
		return base.swap(p1, p2);
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return base.next;
	}

	override @property uint flags() nothrow pure const
	{
		return base.flags;
	}

	override const(void)[] init() nothrow pure const
	{
		return base.init();
	}

	override @property size_t talign() nothrow pure const
	{
		return 16;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		return base.argTypes(arg1, arg2);
	}

	TypeInfo base;
}

class TypeInfo_Function : TypeInfo
{
	override string toString() const
	{
		return cast(string)("function()");
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	// BUG: need to add the rest of the functions

	override @property size_t tsize() nothrow pure const
	{
		return 0; // no size for functions
	}

	override const(void)[] init() const @safe
	{
		return null;
	}

	TypeInfo next;
	string deco;
}

class TypeInfo_Delegate : TypeInfo
{
	override string toString() const
	{
		return cast(string)("delegate()");
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	// BUG: need to add the rest of the functions

	override @property size_t tsize() nothrow pure const
	{
		alias int delegate() dg;
		return dg.sizeof;
	}

	override const(void)[] init() const @trusted
	{
		return (cast(void*) null)[0 .. (int delegate()).sizeof];
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	TypeInfo next;
	string deco;

	override @property size_t talign() nothrow pure const
	{
		alias int delegate() dg;
		return dg.alignof;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		arg1 = typeid(void*);
		arg2 = typeid(void*);
		return 0;
	}
}

/**
 * Runtime type information about a class.
 * Can be retrieved from an object instance by using the
 * $(LINK2 ../property.html#classinfo, .classinfo) property.
 */
class TypeInfo_Class : TypeInfo
{
	override string toString() const
	{
		return info.name;
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @trusted const
	{
		auto o = *cast(Object*) p;
		return o ? o.toHash() : 0;
	}

	override bool equals(in void* p1, in void* p2) const
	{
		Object o1 = *cast(Object*) p1;
		Object o2 = *cast(Object*) p2;

		return (o1 is o2) || (o1 && o1.opEquals(o2));
	}

	override int compare(in void* p1, in void* p2) const
	{
		Object o1 = *cast(Object*) p1;
		Object o2 = *cast(Object*) p2;
		int c = 0;

		// Regard null references as always being "less than"
		if (o1 !is o2)
		{
			if (o1)
			{
				if (!o2)
					c = 1;
				else
					c = o1.opCmp(o2);
			}
			else
				c = -1;
		}
		return c;
	}

	override @property size_t tsize() nothrow pure const
	{
		return Object.sizeof;
	}

	override const(void)[] init() nothrow pure const @safe
	{
		return m_init;
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	override @property const(OffsetTypeInfo)[] offTi() nothrow pure const
	{
		return m_offTi;
	}

	@property auto info() @safe nothrow pure const
	{
		return this;
	}

	@property auto typeinfo() @safe nothrow pure const
	{
		return this;
	}

	byte[] m_init; /** class static initializer
                                 * (init.length gives size in bytes of class)
                                 */
	string name; /// class name
	void*[] vtbl; /// virtual function pointer table
	Interface[] interfaces; /// interfaces this class implements
	TypeInfo_Class base; /// base class
	void* destructor;
	void function(Object) classInvariant;
	enum ClassFlags : uint
	{
		isCOMclass = 0x1,
		noPointers = 0x2,
		hasOffTi = 0x4,
		hasCtor = 0x8,
		hasGetMembers = 0x10,
		hasTypeInfo = 0x20,
		isAbstract = 0x40,
		isCPPclass = 0x80,
		hasDtor = 0x100,
	}

	ClassFlags m_flags;
	void* deallocator;
	OffsetTypeInfo[] m_offTi;
	void function(Object) defaultConstructor; // default Constructor

	immutable(void)* m_RTInfo; // data for precise GC
	override @property immutable(void)* rtInfo() const
	{
		return m_RTInfo;
	}

	/**
     * Search all modules for TypeInfo_Class corresponding to classname.
     * Returns: null if not found
     */
	static const(TypeInfo_Class) find(in char[] classname)
	{
		return null;
	}

	/**
     * Create instance of Object represented by 'this'.
     */
	Object create() const
	{
		if (m_flags & 8 && !defaultConstructor)
			return null;
		if (m_flags & 64) // abstract
			return null;
		Object o = _d_newclass(this);
		if (m_flags & 8 && defaultConstructor)
		{
			defaultConstructor(o);
		}
		return o;
	}
}

alias TypeInfo_Class ClassInfo;

class TypeInfo_Interface : TypeInfo
{
	override string toString() const
	{
		return info.name;
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @trusted const
	{
		Interface* pi = **cast(Interface***)*cast(void**) p;
		Object o = cast(Object)(*cast(void**) p - pi.offset);
		assert(o);
		return o.toHash();
	}

	override bool equals(in void* p1, in void* p2) const
	{
		Interface* pi = **cast(Interface***)*cast(void**) p1;
		Object o1 = cast(Object)(*cast(void**) p1 - pi.offset);
		pi = **cast(Interface***)*cast(void**) p2;
		Object o2 = cast(Object)(*cast(void**) p2 - pi.offset);

		return o1 == o2 || (o1 && o1.opCmp(o2) == 0);
	}

	override int compare(in void* p1, in void* p2) const
	{
		Interface* pi = **cast(Interface***)*cast(void**) p1;
		Object o1 = cast(Object)(*cast(void**) p1 - pi.offset);
		pi = **cast(Interface***)*cast(void**) p2;
		Object o2 = cast(Object)(*cast(void**) p2 - pi.offset);
		int c = 0;

		// Regard null references as always being "less than"
		if (o1 != o2)
		{
			if (o1)
			{
				if (!o2)
					c = 1;
				else
					c = o1.opCmp(o2);
			}
			else
				c = -1;
		}
		return c;
	}

	override @property size_t tsize() nothrow pure const
	{
		return Object.sizeof;
	}

	override const(void)[] init() const @trusted
	{
		return (cast(void*) null)[0 .. Object.sizeof];
	}

	override @property uint flags() nothrow pure const
	{
		return 1;
	}

	TypeInfo_Class info;
}

class TypeInfo_Struct : TypeInfo
{
	override string toString() const
	{
		return name;
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) @safe pure nothrow const
	{
		return cast(size_t)(p);
	}

	override bool equals(in void* p1, in void* p2) @trusted pure nothrow const
	{

		if (!p1 || !p2)
			return false;
		else if (xopEquals)
			return (*xopEquals)(p1, p2);
		else if (p1 == p2)
			return true;
		else // BUG: relies on the GC not moving objects
			return memcmp(p1, p2, init().length) == 0;
	}

	override int compare(in void* p1, in void* p2) @trusted pure nothrow const
	{

		// Regard null references as always being "less than"
		if (p1 != p2)
		{
			if (p1)
			{
				if (!p2)
					return true;
				else if (xopCmp)
					return (*xopCmp)(p2, p1);
				else // BUG: relies on the GC not moving objects
					return memcmp(p1, p2, init().length);
			}
			else
				return -1;
		}
		return 0;
	}

	override @property size_t tsize() nothrow pure const
	{
		return init().length;
	}

	override const(void)[] init() nothrow pure const @safe
	{
		return m_init;
	}

	override @property uint flags() nothrow pure const
	{
		return m_flags;
	}

	override @property size_t talign() nothrow pure const
	{
		return m_align;
	}

	final override void destroy(void* p) const
	{
		if (xdtor)
		{
			if (m_flags & StructFlags.isDynamicType)
				(*xdtorti)(p, this);
			else
				(*xdtor)(p);
		}
	}

	override void postblit(void* p) const
	{
		if (xpostblit)
			(*xpostblit)(p);
	}

	string name;
	void[] m_init; // initializer; init.ptr == null if 0 initialize

	@safe pure nothrow
	{
		size_t function(in void*) xtoHash;
		bool function(in void*, in void*) xopEquals;
		int function(in void*, in void*) xopCmp;
		string function(in void*) xtoString;

		enum StructFlags : uint
		{
			hasPointers = 0x1,
			isDynamicType = 0x2, // built at runtime, needs type info in xdtor
		}

		StructFlags m_flags;
	}
	union
	{
		void function(void*) xdtor;
		void function(void*, const TypeInfo_Struct ti) xdtorti;
	}

	void function(void*) xpostblit;

	uint m_align;

	override @property immutable(void)* rtInfo() const
	{
		return m_RTInfo;
	}

	version (X86_64)
	{
		override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
		{
			arg1 = m_arg1;
			arg2 = m_arg2;
			return 0;
		}

		TypeInfo m_arg1;
		TypeInfo m_arg2;
	}
	immutable(void)* m_RTInfo; // data for precise GC
}

class TypeInfo_Tuple : TypeInfo
{
	TypeInfo[] elements;

	override string toString() const
	{
		return "TUPLE";
	}

	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) const
	{
		assert(0);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		assert(0);
	}

	override int compare(in void* p1, in void* p2) const
	{
		assert(0);
	}

	override @property size_t tsize() nothrow pure const
	{
		assert(0);
	}

	override const(void)[] init() const @trusted
	{
		assert(0);
	}

	override void swap(void* p1, void* p2) const
	{
		assert(0);
	}

	override void destroy(void* p) const
	{
		assert(0);
	}

	override void postblit(void* p) const
	{
		assert(0);
	}

	override @property size_t talign() nothrow pure const
	{
		assert(0);
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		assert(0);
	}
}

class TypeInfo_Const : TypeInfo
{
	override string toString() const
	{
		return "CONST()";
	}

	//override bool opEquals(Object o) { return base.opEquals(o); }
	override bool opEquals(Object o)
	{
		return this is o;
	}

	override size_t getHash(in void* p) const
	{
		return base.getHash(p);
	}

	override bool equals(in void* p1, in void* p2) const
	{
		return base.equals(p1, p2);
	}

	override int compare(in void* p1, in void* p2) const
	{
		return base.compare(p1, p2);
	}

	override @property size_t tsize() nothrow pure const
	{
		return base.tsize;
	}

	override void swap(void* p1, void* p2) const
	{
		return base.swap(p1, p2);
	}

	override @property inout(TypeInfo) next() nothrow pure inout
	{
		return base.next;
	}

	override @property uint flags() nothrow pure const
	{
		return base.flags;
	}

	override const(void)[] init() nothrow pure const
	{
		return base.init();
	}

	override @property size_t talign() nothrow pure const
	{
		return base.talign;
	}

	version (X86_64) override int argTypes(out TypeInfo arg1, out TypeInfo arg2)
	{
		return base.argTypes(arg1, arg2);
	}

	TypeInfo base;
}

class TypeInfo_Invariant : TypeInfo_Const
{
	override string toString() const
	{
		return "IMMUT()";
	}
}

class TypeInfo_Shared : TypeInfo_Const
{
	override string toString() const
	{
		return "SHARED()";
	}
}

class TypeInfo_Inout : TypeInfo_Const
{
	override string toString() const
	{
		return "INOUT()";
	}
}

///////////////////////////////////////////////////////////////////////////////
// ModuleInfo
///////////////////////////////////////////////////////////////////////////////

enum 
{
	MIctorstart = 0x1, // we've started constructing it
	MIctordone = 0x2, // finished construction
	MIstandalone = 0x4, // module ctor does not depend on other module
	// ctors being done first
	MItlsctor = 8,
	MItlsdtor = 0x10,
	MIctor = 0x20,
	MIdtor = 0x40,
	MIxgetMembers = 0x80,
	MIictor = 0x100,
	MIunitTest = 0x200,
	MIimportedModules = 0x400,
	MIlocalClasses = 0x800,
	MIname = 0x1000,
}

struct ModuleInfo
{
	uint _flags;
	uint _index; // index into _moduleinfo_array[]

	version (all)
	{
		deprecated("ModuleInfo cannot be copy-assigned because it is a variable-sized struct.") void opAssign(
			in ModuleInfo m)
		{
			_flags = m._flags;
			_index = m._index;
		}
	}
	else
	{
		@disable this();
		@disable this(this) const;
	}

const:
	private void* addrOf(int flag) nothrow pure
	in
	{
		assert(flag >= MItlsctor && flag <= MIname);
		assert(!(flag & (flag - 1)) && !(flag & ~(flag - 1) << 1));
	}
	body
	{

		void* p = cast(void*)&this + ModuleInfo.sizeof;

		if (flags & MItlsctor)
		{
			if (flag == MItlsctor)
				return p;
			p += typeof(tlsctor).sizeof;
		}
		if (flags & MItlsdtor)
		{
			if (flag == MItlsdtor)
				return p;
			p += typeof(tlsdtor).sizeof;
		}
		if (flags & MIctor)
		{
			if (flag == MIctor)
				return p;
			p += typeof(ctor).sizeof;
		}
		if (flags & MIdtor)
		{
			if (flag == MIdtor)
				return p;
			p += typeof(dtor).sizeof;
		}
		if (flags & MIxgetMembers)
		{
			if (flag == MIxgetMembers)
				return p;
			p += typeof(xgetMembers).sizeof;
		}
		if (flags & MIictor)
		{
			if (flag == MIictor)
				return p;
			p += typeof(ictor).sizeof;
		}
		if (flags & MIunitTest)
		{
			if (flag == MIunitTest)
				return p;
			p += typeof(unitTest).sizeof;
		}
		if (flags & MIimportedModules)
		{
			if (flag == MIimportedModules)
				return p;
			p += size_t.sizeof + *cast(size_t*) p * typeof(importedModules[0]).sizeof;
		}
		if (flags & MIlocalClasses)
		{
			if (flag == MIlocalClasses)
				return p;
			p += size_t.sizeof + *cast(size_t*) p * typeof(localClasses[0]).sizeof;
		}
		if (true || flags & MIname) // always available for now
		{
			if (flag == MIname)
				return p;
			p += strlen(cast(immutable char*) p);
		}
		assert(0);
	}

	@property uint index() nothrow pure
	{
		return _index;
	}

	@property uint flags() nothrow pure
	{
		return _flags;
	}

	@property void function() tlsctor() nothrow pure
	{
		return flags & MItlsctor ? *cast(typeof(return)*) addrOf(MItlsctor) : null;
	}

	@property void function() tlsdtor() nothrow pure
	{
		return flags & MItlsdtor ? *cast(typeof(return)*) addrOf(MItlsdtor) : null;
	}

	@property void* xgetMembers() nothrow pure
	{
		return flags & MIxgetMembers ? *cast(typeof(return)*) addrOf(MIxgetMembers) : null;
	}

	@property void function() ctor() nothrow pure
	{
		return flags & MIctor ? *cast(typeof(return)*) addrOf(MIctor) : null;
	}

	@property void function() dtor() nothrow pure
	{
		return flags & MIdtor ? *cast(typeof(return)*) addrOf(MIdtor) : null;
	}

	@property void function() ictor() nothrow pure
	{
		return flags & MIictor ? *cast(typeof(return)*) addrOf(MIictor) : null;
	}

	@property void function() unitTest() nothrow pure
	{
		return flags & MIunitTest ? *cast(typeof(return)*) addrOf(MIunitTest) : null;
	}

	@property immutable(ModuleInfo*)[] importedModules() nothrow pure
	{
		if (flags & MIimportedModules)
		{
			auto p = cast(size_t*) addrOf(MIimportedModules);
			return (cast(immutable(ModuleInfo*)*)(p + 1))[0 .. *p];
		}
		return null;
	}

	@property TypeInfo_Class[] localClasses() nothrow pure
	{
		if (flags & MIlocalClasses)
		{
			auto p = cast(size_t*) addrOf(MIlocalClasses);
			return (cast(TypeInfo_Class*)(p + 1))[0 .. *p];
		}
		return null;
	}

	@property string name() nothrow pure
	{
		if (true || flags & MIname) // always available for now
		{

			auto p = cast(immutable char*) addrOf(MIname);
			return p[0 .. strlen(p)];
		}
		// return null;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Throwable
///////////////////////////////////////////////////////////////////////////////

/**
 * The base class of all thrown objects.
 *
 * All thrown objects must inherit from Throwable. Class $(D Exception), which
 * derives from this class, represents the category of thrown objects that are
 * safe to catch and handle. In principle, one should not catch Throwable
 * objects that are not derived from $(D Exception), as they represent
 * unrecoverable runtime errors. Certain runtime guarantees may fail to hold
 * when these errors are thrown, making it unsafe to continue execution after
 * catching them.
 */
class Throwable : Object
{
	interface TraceInfo
	{
		int opApply(scope int delegate(ref const(char[]))) const;
		int opApply(scope int delegate(ref size_t, ref const(char[]))) const;
		string toString() const;
	}

	string msg; /// A message describing the error.

	/**
     * The _file name and line number of the D source code corresponding with
     * where the error was thrown from.
     */
	string file;
	size_t line; /// ditto

	/**
     * The stack trace of where the error happened. This is an opaque object
     * that can either be converted to $(D string), or iterated over with $(D
     * foreach) to extract the items in the stack trace (as strings).
     */
	TraceInfo info;

	/**
     * A reference to the _next error in the list. This is used when a new
     * $(D Throwable) is thrown from inside a $(D catch) block. The originally
     * caught $(D Exception) will be chained to the new $(D Throwable) via this
     * field.
     */
	Throwable next;

	@nogc @safe pure nothrow this(string msg, Throwable next = null)
	{
		this.msg = msg;
		this.next = next;
		//this.info = _d_traceContext();
	}

	@nogc @safe pure nothrow this(string msg, string file, size_t line, Throwable next = null)
	{
		this(msg, next);
		this.file = file;
		this.line = line;
		//this.info = _d_traceContext();
	}

	/**
     * Overrides $(D Object.toString) and returns the error message.
     * Internally this forwards to the $(D toString) overload that
     * takes a $(PARAM sink) delegate.
     */
	override string toString()
	{
		return msg;
	}

	/**
     * The Throwable hierarchy uses a toString overload that takes a
     * $(PARAM sink) delegate to avoid GC allocations, which cannot be
     * performed in certain error situations.  Override this $(D
     * toString) method to customize the error message.
     */
	void toString(scope void delegate(in char[]) sink) const
	{

	}
}

/**
 * The base class of all errors that are safe to catch and handle.
 *
 * In principle, only thrown objects derived from this class are safe to catch
 * inside a $(D catch) block. Thrown objects not derived from Exception
 * represent runtime errors that should not be caught, as certain runtime
 * guarantees may not hold, making it unsafe to continue program execution.
 */
class Exception : Throwable
{

	/**
     * Creates a new instance of Exception. The next parameter is used
     * internally and should always be $(D null) when passed by user code.
     * This constructor does not automatically throw the newly-created
     * Exception; the $(D throw) statement should be used for that purpose.
     */
	@nogc @safe pure nothrow this(string msg, string file = __FILE__,
		size_t line = __LINE__, Throwable next = null)
	{
		super(msg, file, line, next);
	}

	@nogc @safe pure nothrow this(string msg, Throwable next,
		string file = __FILE__, size_t line = __LINE__)
	{
		super(msg, file, line, next);
	}
}

/**
 * The base class of all unrecoverable runtime errors.
 *
 * This represents the category of $(D Throwable) objects that are $(B not)
 * safe to catch and handle. In principle, one should not catch Error
 * objects, as they represent unrecoverable runtime errors.
 * Certain runtime guarantees may fail to hold when these errors are
 * thrown, making it unsafe to continue execution after catching them.
 */
class Error : Throwable
{
	/**
     * Creates a new instance of Error. The next parameter is used
     * internally and should always be $(D null) when passed by user code.
     * This constructor does not automatically throw the newly-created
     * Error; the $(D throw) statement should be used for that purpose.
     */
	@nogc @safe pure nothrow this(string msg, Throwable next = null)
	{
		super(msg, next);
		bypassedException = null;
	}

	@nogc @safe pure nothrow this(string msg, string file, size_t line, Throwable next = null)
	{
		super(msg, file, line, next);
		bypassedException = null;
	}

	/// The first $(D Exception) which was bypassed when this Error was thrown,
	/// or $(D null) if no $(D Exception)s were pending.
	Throwable bypassedException;
}

private void _destructRecurse(S)(ref S s) if (is(S == struct))
{
	static if (__traits(hasMember, S, "__xdtor")
			&&  // Bugzilla 14746: Check that it's the exact member of S.
			__traits(isSame, S, __traits(parent, s.__xdtor)))
		s.__xdtor();
}

// Public and explicitly undocumented
void _postblitRecurse(S)(ref S s) if (is(S == struct))
{
	static if (__traits(hasMember, S, "__xpostblit")
			&&  // Bugzilla 14746: Check that it's the exact member of S.
			__traits(isSame, S,
			__traits(parent, s.__xpostblit)))
		s.__xpostblit();
}

/++
    Destroys the given object and puts it in an invalid state. It's used to
    destroy an object so that any cleanup which its destructor or finalizer
    does is done and so that it no longer references any other objects. It does
    $(I not) initiate a GC cycle or free any GC memory.
  +/
void destroy(T)(T obj)
{
	static assert(0);
}

template _isStaticArray(T : U[N], U, size_t N)
{
	enum bool _isStaticArray = true;
}

template _isStaticArray(T)
{
	enum bool _isStaticArray = false;
}

/***************************************
 * Helper function used to see if two containers of different
 * types have the same contents in the same sequence.
 */

bool _ArrayEq(T1, T2)(T1[] a1, T2[] a2)
{
	if (a1.length != a2.length)
		return false;
	foreach (i, a; a1)
	{
		if (a != a2[i])
			return false;
	}
	return true;
}

/**
Calculates the hash value of $(D arg) with $(D seed) initial value.
Result may be non-equals with $(D typeid(T).getHash(&arg))
The $(D seed) value may be used for hash chaining:
----
struct Test
{
    int a;
    string b;
    MyObject c;

    size_t toHash() const @safe pure nothrow
    {
        size_t hash = a.hashOf();
        hash = b.hashOf(hash);
        size_t h1 = c.myMegaHash();
        hash = h1.hashOf(hash); //Mix two hash values
        return hash;
    }
}
----
*/
size_t hashOf(T)(auto ref T arg, size_t seed = 0)
{
	return cast(size_t) arg;
}

bool _xopEquals(in void*, in void*)
{
	assert(0);
}

bool _xopCmp(in void*, in void*)
{
	assert(0);
}

/******************************************
 * Create RTInfo for type T
 */

template RTInfo(T)
{
	enum RTInfo = null;
}

// Helper functions

private inout(TypeInfo) getElement(inout TypeInfo value) @trusted pure nothrow
{
	TypeInfo element = cast() value;
	for (;;)
	{
		if (auto qualified = cast(TypeInfo_Const) element)
			element = qualified.base;
		else if (auto redefined = cast(TypeInfo_Typedef) element) // typedef & enum
			element = redefined.base;
		else if (auto staticArray = cast(TypeInfo_StaticArray) element)
			element = staticArray.value;
		else if (auto vector = cast(TypeInfo_Vector) element)
			element = vector.base;
		else
			break;
	}
	return cast(inout) element;
}

private size_t getArrayHash(in TypeInfo element, in void* ptr, in size_t count) @trusted nothrow
{
	return cast(size_t) ptr;
}
