/// Basic C library functions and some utilities
module barec;

nothrow:
@nogc:

extern (C) void* kmalloc(size_t size);
extern (C) void* krealloc(void* ptr, size_t newsize);
extern (C) void* kcalloc(size_t nmemb, size_t size);
extern (C) void kfree(void* ptr);

auto max(T, U)(T a, U b)
{
    return (a > b) ? a : b;
}

auto min(T, U)(T a, U b)
{
    return (a < b) ? a : b;
}

template octal(T, string val)
{
    enum T octal = octalf!T(val);
}

private T octalf(T)(string lit)
{
    ulong pow = 1;
    T val = 0;
    for (int i = cast(int)(lit.length - 1); i >= 0; i--)
    {
        if ((lit[i] < '0') || (lit[i] > '7'))
            continue;
        val += cast(T)(pow * (lit[i] - '0'));
        pow *= 8;
    }
    return val;
}

/// Used from https://github.com/Vild/PowerNex project
template Bitfield(alias data, Args...)
{
    const char[] Bitfield = BitfieldShim!((typeof(data)).stringof, data, Args).Ret;
}
/// ditto
template BitfieldShim(const char[] typeStr, alias data, Args...)
{
    const char[] Name = data.stringof;
    const char[] Ret = BitfieldImpl!(typeStr, Name, 0, Args).Ret;
}
/// ditto
template BitfieldImpl(const char[] typeStr, const char[] nameStr, int offset, Args...)
{
    static if (!Args.length)
        const char[] Ret = "";
    else
    {
        const Name = Args[0];
        const Size = Args[1];
        const Mask = Bitmask!Size;
        const Type = TargetType!Size;

        const char[] Getter = "@property " ~ Type ~ " " ~ Name ~ "() nothrow @nogc { return cast(" ~ Type
            ~ ")((" ~ nameStr ~ " >> " ~ Itoh!(offset) ~ ") & " ~ Itoh!(Mask) ~ "); } \n";

        const char[] Setter = "@property void " ~ Name ~ "(" ~ Type ~ " val) nothrow @nogc { " ~ nameStr
            ~ " = (" ~ nameStr ~ " & " ~ Itoh!(~(Mask << offset)) ~ ") | ((val & " ~ Itoh!(
                    Mask) ~ ") << " ~ Itoh!(offset) ~ "); } \n";

        const char[] Ret = Getter ~ Setter ~ BitfieldImpl!(typeStr, nameStr,
                offset + Size, Args[2 .. $]).Ret;
    }
}
/// ditto
template Bitmask(long size)
{
    const long Bitmask = (1UL << size) - 1;
}
/// ditto
template TargetType(long size)
{
    static if (size == 1)
        const TargetType = "bool";
    else static if (size <= 8)
        const TargetType = "ubyte";
    else static if (size <= 16)
        const TargetType = "ushort";
    else static if (size <= 32)
        const TargetType = "uint";
    else static if (size <= 64)
        const TargetType = "ulong";
    else
        static assert(0);
}
/// ditto
template Itoh(long i)
{
    const char[] Itoh = "0x" ~ IntToStr!(i, 16) ~ "UL";
}
/// ditto
template Digits(long i)
{
    const char[] Digits = "0123456789abcdefghijklmnopqrstuvwxyz"[0 .. i];
}
/// ditto
template IntToStr(ulong i, int base)
{
    static if (i >= base)
        const char[] IntToStr = IntToStr!(i / base, base) ~ Digits!base[i % base];
    else
        const char[] IntToStr = "" ~ Digits!base[i % base];
}
/// ditto
template IntToWStr(ulong i, int base)
{
    static if (i >= base)
        const wchar[] IntToWStr = IntToWStr!(i / base, base) ~ cast(wchar) Digits!base[i % base];
    else
        const wchar[] IntToWStr = ""w ~ cast(wchar) Digits!base[i % base];
}

// String+Memory
extern (C):
@system:
///
pure void* memchr(in void* s, int c, size_t n)
{
    const(void)* end = s + n;
    for (ubyte* p = cast(ubyte*) s; p !is end; p++)
    {
        if ((*p) == c)
            return p;
    }
    return null;
}
///
pure int memcmp(in void* s1, in void* s2, size_t n)
{
    const(void)* end = s1 + n;
    for (ubyte* p = cast(ubyte*) s1, q = cast(ubyte*) s2; p !is end; p++, q++)
    {
        if ((*p) < (*q))
            return -1;
        else if ((*p) > (*q))
            return 1;
    }
    return 0;
}
///
pure void* memcpy(void* s1, in void* s2, size_t n)
{
    const(void)* end = s1 + n;
    for (ubyte* p = cast(ubyte*) s1, q = cast(ubyte*) s2; p !is end; p++, q++)
    {
        *p = *q;
    }
    return s1;
}
///
pure void* memmove(void* s1, in void* s2, size_t n)
{
    const(void)* end = s1 + n;
    for (ubyte* p = cast(ubyte*) s1, q = cast(ubyte*) s2; p !is end; p++, q++)
    {
        *p = *q;
    }
    return s1;
}
///
pure void* memset(void* s, int c, size_t n)
{
    const(void)* end = s + n;
    for (ubyte* p = cast(ubyte*) s; p !is end; p++)
    {
        *p = cast(ubyte) c;
    }
    return s;
}

///
pure char* strcpy(char* s1, in char* s2)
{
    char* p, q;
    for (p = cast(char*) s1, q = cast(char*) s2; (*q) != '\0'; p++, q++)
    {
        *p = *q;
    }
    *p = '\0';
    return s1;
}
///
pure char* strncpy(char* s1, in char* s2, size_t n)
{
    const(char)* end = s1 + n;
    char* p, q;
    for (p = cast(char*) s1, q = cast(char*) s2; ((*q) != '\0') && (p !is end); p++, q++)
    {
        *p = *q;
    }
    if (p !is end)
        *p = '\0';
    return s1;
}
///stub
pure char* strcat(char* s1, in char* s2)
{
    return s1;
}
///stub
pure char* strncat(char* s1, in char* s2, size_t n)
{
    return s1;
}
///
pure int strcmp(in char* s1, in char* s2)
{
    size_t l1 = strlen(s1);
    size_t l2 = strlen(s2);
    return memcmp(s1, s2, min(l1, l2));
}
///
int strcoll(in char* s1, in char* s2)
{
    size_t l1 = strlen(s1);
    size_t l2 = strlen(s2);
    return memcmp(s1, s2, min(l1, l2));
}
///
pure int strncmp(in char* s1, in char* s2, size_t n)
{
    size_t l1 = strnlen(s1, n);
    size_t l2 = strnlen(s2, n);
    return memcmp(s1, s2, min(l1, l2));
}
///
size_t strxfrm(char* s1, in char* s2, size_t n)
{
    return 0;
}
///
pure char* strchr(in char* s, int c)
{
    size_t l1 = strlen(s);
    return cast(char*) memchr(s, c, l1);
}
///
pure size_t strcspn(in char* s1, in char* s2)
{
    char* p;
    for (p = cast(char*) s1; (*p) != '\0'; p++)
    {
        for (char* q = cast(char*) s2; (*q) != '\0'; q++)
        {
            if ((*q) == (*p))
                return (p - s1);
        }
    }
    return p - s1;
}
///
pure char* strpbrk(in char* s1, in char* s2)
{
    char* p;
    for (p = cast(char*) s1; (*p) != '\0'; p++)
    {
        for (char* q = cast(char*) s2; (*q) != '\0'; q++)
        {
            if ((*q) == (*p))
                return p;
        }
    }
    return null;
}
///
pure char* strrchr(in char* s, int c)
{
    char* tmp = null;
    size_t len = 0;
    for (char* p = cast(char*) s; (*p) != '\0'; p++)
    {
        if ((*p) == c)
            tmp = p;
        len++;
    }
    return (tmp is null) ? cast(char*)(s + len) : tmp;
}
///
pure size_t strspn(in char* s1, in char* s2)
{
    char* p;
    for (p = cast(char*) s1; (*p) != '\0'; p++)
    {
        bool flag = false;
        for (char* q = cast(char*) s2; (*q) != '\0'; q++)
        {
            if ((*q) == (*p))
                flag = true;
        }
        if (!flag)
            return p - s1;
    }
    return p - s1;
}
///
pure char* strstr(in char* s1, in char* s2)
{
    char* s = cast(char*) s1;
    char* find = cast(char*) s2;
    char c, sc;
    size_t len;

    if ((c = *find++) != 0)
    {
        len = strlen(find);
        do
        {
            do
            {
                if ((sc = *s++) == 0)
                    return null;
            }
            while (sc != c);
        }
        while (strncmp(s, find, len) != 0);
        s--;
    }
    return s;
}
///
char* strtok(char* s1, in char* s2)
{
    return null;
}
///
char* strerror(int errnum)
{
    if (errnum == 0)
    {
        return cast(char*) "0";
    }
    else
    {
        return cast(char*) "1";
    }
}
///
void abort()
{
    while (1)
    {
    }
}
///
pure size_t strlen(in char* s)
{
    size_t len = 0;
    for (char* p = cast(char*) s; (*p) != '\0'; p++)
    {
        len++;
    }
    return len;
}
///
pure size_t strnlen(in char* s, size_t n)
{
    size_t len = 0;
    for (char* p = cast(char*) s; ((*p) != '\0') && (len < n); p++)
    {
        len++;
    }
    return len;
}
///
char* strdup(in char* s)
{
    return cast(char*) s;
}

/// Some constants and types
alias wchar_t = wchar;

///
alias int8_t = byte;
///
alias int16_t = short;
///
alias int32_t = int;
///
alias int64_t = long;
//alias int128_t = cent;

///
alias uint8_t = ubyte;
///
alias uint16_t = ushort;
///
alias uint32_t = uint;
///
alias uint64_t = ulong;
//alias uint128_t = ucent;

///
alias int_least8_t = byte;
///
alias int_least16_t = short;
///
alias int_least32_t = int;
///
alias int_least64_t = long;

///
alias uint_least8_t = ubyte;
///
alias uint_least16_t = ushort;
///
alias uint_least32_t = uint;
///
alias uint_least64_t = ulong;

///
alias int_fast8_t = byte;
///
alias int_fast16_t = int;
///
alias int_fast32_t = int;
///
alias int_fast64_t = long;

///
alias uint_fast8_t = ubyte;
///
alias uint_fast16_t = uint;
///
alias uint_fast32_t = uint;
///
alias uint_fast64_t = ulong;

version (D_LP64)
{
    ///
    alias intptr_t = long;
    ///
    alias uintptr_t = ulong;
}
else
{
    ///
    alias intptr_t = int;
    ///
    alias uintptr_t = uint;
}

///
alias intmax_t = long;
///
alias uintmax_t = ulong;

///
enum int8_t INT8_MIN = int8_t.min;
///
enum int8_t INT8_MAX = int8_t.max;
///
enum int16_t INT16_MIN = int16_t.min;
///
enum int16_t INT16_MAX = int16_t.max;
///
enum int32_t INT32_MIN = int32_t.min;
///
enum int32_t INT32_MAX = int32_t.max;
///
enum int64_t INT64_MIN = int64_t.min;
///
enum int64_t INT64_MAX = int64_t.max;

///
enum uint8_t UINT8_MAX = uint8_t.max;
///
enum uint16_t UINT16_MAX = uint16_t.max;
///
enum uint32_t UINT32_MAX = uint32_t.max;
///
enum uint64_t UINT64_MAX = uint64_t.max;

///
enum int_least8_t INT_LEAST8_MIN = int_least8_t.min;
///
enum int_least8_t INT_LEAST8_MAX = int_least8_t.max;
///
enum int_least16_t INT_LEAST16_MIN = int_least16_t.min;
///
enum int_least16_t INT_LEAST16_MAX = int_least16_t.max;
///
enum int_least32_t INT_LEAST32_MIN = int_least32_t.min;
///
enum int_least32_t INT_LEAST32_MAX = int_least32_t.max;
///
enum int_least64_t INT_LEAST64_MIN = int_least64_t.min;
///
enum int_least64_t INT_LEAST64_MAX = int_least64_t.max;

///
enum uint_least8_t UINT_LEAST8_MAX = uint_least8_t.max;
///
enum uint_least16_t UINT_LEAST16_MAX = uint_least16_t.max;
///
enum uint_least32_t UINT_LEAST32_MAX = uint_least32_t.max;
///
enum uint_least64_t UINT_LEAST64_MAX = uint_least64_t.max;

///
enum int_fast8_t INT_FAST8_MIN = int_fast8_t.min;
///
enum int_fast8_t INT_FAST8_MAX = int_fast8_t.max;
///
enum int_fast16_t INT_FAST16_MIN = int_fast16_t.min;
///
enum int_fast16_t INT_FAST16_MAX = int_fast16_t.max;
///
enum int_fast32_t INT_FAST32_MIN = int_fast32_t.min;
///
enum int_fast32_t INT_FAST32_MAX = int_fast32_t.max;
///
enum int_fast64_t INT_FAST64_MIN = int_fast64_t.min;
///
enum int_fast64_t INT_FAST64_MAX = int_fast64_t.max;

///
enum uint_fast8_t UINT_FAST8_MAX = uint_fast8_t.max;
///
enum uint_fast16_t UINT_FAST16_MAX = uint_fast16_t.max;
///
enum uint_fast32_t UINT_FAST32_MAX = uint_fast32_t.max;
///
enum uint_fast64_t UINT_FAST64_MAX = uint_fast64_t.max;

///
enum intptr_t INTPTR_MIN = intptr_t.min;
///
enum intptr_t INTPTR_MAX = intptr_t.max;

///
enum uintptr_t UINTPTR_MIN = uintptr_t.min;
///
enum uintptr_t UINTPTR_MAX = uintptr_t.max;

///
enum intmax_t INTMAX_MIN = intmax_t.min;
///
enum intmax_t INTMAX_MAX = intmax_t.max;

///
enum uintmax_t UINTMAX_MAX = uintmax_t.max;

///
enum ptrdiff_t PTRDIFF_MIN = ptrdiff_t.min;
///
enum ptrdiff_t PTRDIFF_MAX = ptrdiff_t.max;

///
enum size_t SIZE_MAX = size_t.max;

///
enum wchar_t WCHAR_MIN = wchar_t.min;
///
enum wchar_t WCHAR_MAX = wchar_t.max;

void abort() @safe
{
    while (1)
    {
        asm nothrow @safe @nogc
        {
            cli;
            hlt;
        }
    }
}
