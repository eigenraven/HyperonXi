module hxi.cpu.interrupts;

import kstdlib;
import hxi.log;
import hxi.cpu.descriptors;
import hxi.cpu.pic;
import asmutils;
import hxi.cpu.ps2;

nothrow:
@nogc:

struct InterruptRegisterState
{
	ulong interruptNumber;
	ulong rax, rbx, rcx, rdx, rsi, rdi, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
	ulong errorCode;
	ulong rip;
	ulong cs;
	ulong rflags;
	ulong rsp;
	ulong ss;
}

void initializeInterrupts()
{
	foreach (i; 0 .. 255)
	{
		kernelIDT[i].selector = SegmentSelector.KernelCode;
		kernelIDT[i].ist = 0;
		kernelIDT[i].type = SystemSegmentType.InterruptGate;
		kernelIDT[i].dpl = 0;
	}
	kernelIDT[0x00].offset = cast(ulong)(&interruptHandler!(0x00, false, hxintDivideByZero));
	kernelIDT[0x00].present = true;

	kernelIDT[0x01].offset = cast(ulong)(&interruptHandler!(0x01, false, hxintBreakpoint));
	kernelIDT[0x01].present = true;

	kernelIDT[0x02].offset = cast(ulong)(&interruptHandler!(0x02, false, hxintNMI));
	kernelIDT[0x02].present = true;

	kernelIDT[0x03].offset = cast(ulong)(&interruptHandler!(0x03, false, hxintBreakpoint));
	kernelIDT[0x03].present = true;

	kernelIDT[0x08].offset = cast(ulong)(&interruptHandler!(0x08, true, hxintDoubleFault));
	kernelIDT[0x08].present = true;

	kernelIDT[0x0D].offset = cast(ulong)(&interruptHandler!(0x0D, true, hxintGPF));
	kernelIDT[0x0D].present = true;

	kernelIDT[0x0E].offset = cast(ulong)(&interruptHandler!(0x0E, true, hxintPageFault));
	kernelIDT[0x0E].present = true;

	enum PIT_IOFFSET = 0x20;
	kernelIDT[PIT_IOFFSET].offset = cast(ulong)(&interruptHandler!(PIT_IOFFSET, false, hxintIrq0));
	kernelIDT[PIT_IOFFSET].present = true;
	kernelIDT[PIT_IOFFSET + 0x1].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x1, false, hxintIrq1));
	kernelIDT[PIT_IOFFSET + 0x1].present = true;
	kernelIDT[PIT_IOFFSET + 0x2].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x2, false, hxintIrq2));
	kernelIDT[PIT_IOFFSET + 0x2].present = true;
	kernelIDT[PIT_IOFFSET + 0x3].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x3, false, hxintIrq3));
	kernelIDT[PIT_IOFFSET + 0x3].present = true;
	kernelIDT[PIT_IOFFSET + 0x4].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x4, false, hxintIrq4));
	kernelIDT[PIT_IOFFSET + 0x4].present = true;
	kernelIDT[PIT_IOFFSET + 0x5].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x5, false, hxintIrq5));
	kernelIDT[PIT_IOFFSET + 0x5].present = true;
	kernelIDT[PIT_IOFFSET + 0x6].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x6, false, hxintIrq6));
	kernelIDT[PIT_IOFFSET + 0x6].present = true;
	kernelIDT[PIT_IOFFSET + 0x7].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x7, false, hxintIrq7));
	kernelIDT[PIT_IOFFSET + 0x7].present = true;
	kernelIDT[PIT_IOFFSET + 0x8].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x8, false, hxintIrq8));
	kernelIDT[PIT_IOFFSET + 0x8].present = true;
	kernelIDT[PIT_IOFFSET + 0x9].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0x9, false, hxintIrq9));
	kernelIDT[PIT_IOFFSET + 0x9].present = true;
	kernelIDT[PIT_IOFFSET + 0xA].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xA, false, hxintIrqA));
	kernelIDT[PIT_IOFFSET + 0xA].present = true;
	kernelIDT[PIT_IOFFSET + 0xB].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xB, false, hxintIrqB));
	kernelIDT[PIT_IOFFSET + 0xB].present = true;
	kernelIDT[PIT_IOFFSET + 0xC].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xC, false, hxintIrqC));
	kernelIDT[PIT_IOFFSET + 0xC].present = true;
	kernelIDT[PIT_IOFFSET + 0xD].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xD, false, hxintIrqD));
	kernelIDT[PIT_IOFFSET + 0xD].present = true;
	kernelIDT[PIT_IOFFSET + 0xE].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xE, false, hxintIrqE));
	kernelIDT[PIT_IOFFSET + 0xE].present = true;
	kernelIDT[PIT_IOFFSET + 0xF].offset = cast(ulong)(
			&interruptHandler!(PIT_IOFFSET + 0xF, false, hxintIrqF));
	kernelIDT[PIT_IOFFSET + 0xF].present = true;

	kernelIDT[0x80].offset = cast(ulong)(&interruptHandler!(0x80, false, hxint80h));
	kernelIDT[0x80].present = true;

	lidt(kernelIDT.ptr, cast(short)(kernelIDT.length * IDTEntry.sizeof));
	PIC.remapInterrupts(PIT_IOFFSET, PIT_IOFFSET + 8);
	foreach (ubyte i; 0 .. 16)
	{
		PIC.sendEOI(i);
		PIC.clearIRQMask(i);
	}
	enableInterrupts();
}

extern (C) private void genericHandler(InterruptRegisterState state)
{
	logf(LogLevel.Error, "Unhandled generic interrupt #%d", state.interruptNumber);
}

extern (C) private void nullHandler(InterruptRegisterState state)
{
	log(LogLevel.Error, "Unhandled interrupt");
}

extern (C) private void hxintDivideByZero(InterruptRegisterState state)
{
	log(LogLevel.Error, "Division by zero!!!");
	criticalFailure;
}

extern (C) private void hxintNMI(InterruptRegisterState state)
{
	log(LogLevel.Warn, "Unhandled NMI");
}

extern (C) private void hxintBreakpoint(InterruptRegisterState state)
{
	log(LogLevel.Warn, "Unhandled breakpoint");
}

extern (C) private void hxintDoubleFault(InterruptRegisterState state)
{
	log(LogLevel.Warn, "Unhandled double fault");
	criticalFailure();
}

extern (C) private void hxintGPF(InterruptRegisterState state)
{
	log(LogLevel.Warn, "Unhandled GPF");
}

extern (C) private void hxintPageFault(InterruptRegisterState state)
{
	log(LogLevel.Warn, "Unhandled page fault");
}

extern (C) private void hxint80h(InterruptRegisterState state)
{
	log(LogLevel.Info, "0x80 Interrupt");
}

__gshared private ubyte C;
__gshared private int mousex, mousey;

import hxi.fbcon.framebuffer;

extern (C) private void hxintIrq0(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0);
	// Timer: PIT
	int D = cast(int) C;
	if (D < 0)
		D += 256;
	activeFramebuffer.drawFilledRect(0x000000, 900, D, 16, 16);
	.C += 10;
	D = cast(int) C;
	if (D < 0)
		D += 256;
	activeFramebuffer.drawFilledRect(mousex + (mousex << 8) + (mousex << 16), 900, D, 16, 16);
	if (PS2Controller.outputFull())
	{
		ubyte code = PS2Controller.readData();
		if (code == 0x76)
			activeFramebuffer.clearText();
		if (code == 0xF0)
		{
			code = PS2Controller.readData();
			logf(LogLevel.Trace, "Key release: %x", cast(ulong) code);
		}
		else
		{
			logf(LogLevel.Trace, "Key press: %x", cast(ulong) code);
		}
	}
}

extern (C) private void hxintIrq1(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(1);
	// PS2 Device 1
	ubyte code = PS2Controller.readData();
	if (code == 0x76)
		activeFramebuffer.clearText();
	if (code == 0xF0)
	{
		code = PS2Controller.readData();
		logf(LogLevel.Trace, "Key release: %x", cast(ulong) code);
	}
	else
	{
		logf(LogLevel.Trace, "Key press: %x", cast(ulong) code);
	}
}

extern (C) private void hxintIrq2(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(2);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq3(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(3);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq4(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(4);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq5(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(5);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq6(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(6);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq7(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(7);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq8(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(8);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrq9(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(9);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrqA(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xA);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrqB(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xB);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrqC(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xC);
	import hxi.cpu.ps2;

	ubyte b0, bx, by;

	b0 = PS2Controller.readData();
	bx = PS2Controller.readData();
	by = PS2Controller.readData();
	int dx, dy;
	dx = bx;
	dy = by;
	if (b0 & 16)
		dx = dx - 0x100;
	if (b0 & 32)
		dy = dy - 0x100;
	dy = -dy;
	activeFramebuffer.drawFilledRect(0, mousex, mousey, 4, 4);
	mousex += dx;
	mousey += dy;
	mousex = clamp(mousex, 0, activeFramebuffer.width);
	mousey = clamp(mousey, 0, activeFramebuffer.height);
	activeFramebuffer.drawFilledRect(0xEEEE44, mousex, mousey, 4, 4);
	PS2Controller.flushBuffer();
}

extern (C) private void hxintIrqD(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xD);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrqE(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xE);
	log(LogLevel.Info, "IRQ");
}

extern (C) private void hxintIrqF(InterruptRegisterState state)
{
	scope (exit)
		PIC.sendEOI(0xF);
	log(LogLevel.Info, "IRQ");
}

private void interruptHandler(int number, bool hasECode = false, alias handler)() nothrow @nogc
{
	asm nothrow @nogc
	{
		naked;
	}
	static if (!hasECode)
	{
		asm nothrow @nogc
		{
			push 0;
		}
	}
	asm nothrow @nogc
	{
		push R15;
		push R14;
		push R13;
		push R12;
		push R11;
		push R10;
		push R9;
		push R8;
		push RBP;
		push RDI;
		push RSI;
		push RDX;
		push RCX;
		push RBX;
		push RAX;
		mov RAX, number;
		push number;

		call handler;

		add RSP, 8; // drop number

		pop RAX;
		pop RBX;
		pop RCX;
		pop RDX;
		pop RSI;
		pop RDI;
		pop RBP;
		pop R8;
		pop R9;
		pop R10;
		pop R11;
		pop R12;
		pop R13;
		pop R14;
		pop R15;
		add RSP, 8; // drop exception code
		iretq;
	}
}
