module asmutils;

import kstdlib;
import ldc.attributes;
import ldc.intrinsics;
import ldc.llvmasm;

nothrow:
@nogc:

void outb(ushort port, ubyte value)
{
	__asm("outb $1, $0", "{dx},{al}", port, value);
}

void outw(ushort port, ushort value)
{
	__asm("outw $1, $0", "{dx},{ax}", port, value);
}

void outl(ushort port, uint value)
{
	__asm("outl $1, $0", "{dx},{eax}", port, value);
}

ubyte inb(ushort port)
{
	return __asm!ubyte("inb $1, $0", "={al},{dx}", port);
}

ushort inw(ushort port)
{
	return __asm!ushort("inw $1, $0", "={ax},{dx}", port);
}

uint inl(ushort port)
{
	return __asm!uint("inl $1, $0", "={eax},{dx}", port);
}

pragma(inline, true) void enableInterrupts()
{
	pragma(LDC_allow_inline);
	__asm("sti", "");
}

pragma(inline, true) void disableInterrupts()
{
	pragma(LDC_allow_inline);
	__asm("cli", "");
}

void io_wait()
{
	__asm("outb $1, $0", "{dx},{al}", cast(ushort) 0x90, cast(ubyte) 0);
}

void repnop()
{
	pragma(LDC_allow_inline);
	__asm("rep nop", "");
}

void flushTLB(ulong vaddr)
{
	asm nothrow @nogc
	{
		mov RAX, vaddr;
		invlpg [RAX];
	}
}

void flushTLB(void* vaddr)
{
	asm nothrow @nogc
	{
		mov RAX, vaddr;
		invlpg [RAX];
	}
}

ulong rdmsr(uint register)
{
	uint low, high;
	asm nothrow @nogc
	{
		mov ECX, register;
		rdmsr;
		mov high, EDX;
		mov low, EAX;
	}
	return low | (cast(ulong) high << 32UL);
}

void wrmsr(uint register, ulong value)
{
	uint low = value & 0xFFFF_FFFFU, high = uint(value >> 32);
	asm nothrow @nogc
	{
		mov ECX, register;
		mov EDX, high;
		mov EAX, low;
		wrmsr;
	}
}

pragma(inline, false) ulong getCR3()
{
	ulong val;
	asm nothrow @nogc
	{
		mov RAX, CR3;
		mov val, RAX;
	}
	return val;
}

pragma(inline, false) void setCR3(ulong val)
{
	asm nothrow @nogc
	{
		mov RAX, val;
		mov CR3, RAX;
	}
}

/// Defined in asmutils.asm
extern (C) void reload_gdt();
