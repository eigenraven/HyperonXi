/// Programmable Interrupt Controller interface
module hxi.cpu.pic;

import kstdlib;
import asmutils;

struct PIC
{
	private enum ushort PIC1 = 0x20;
	private enum ushort PIC2 = 0xA0;
	private enum ushort PIC1CMD = PIC1;
	private enum ushort PIC1DAT = PIC1 + 1;
	private enum ushort PIC2CMD = PIC2;
	private enum ushort PIC2DAT = PIC2 + 1;

	private enum PicCommand : ubyte
	{
		eoi = 0x20,
		readIRR = 0x0a,
		readISR = 0x0b,
	}

static:
nothrow:
@nogc:

	/// Sends end of interrupt signal
	void sendEOI(int irq)
	{
		if (irq >= 8)
			outb(PIC2CMD, PicCommand.eoi);
		outb(PIC1CMD, PicCommand.eoi);
	}

	void remapInterrupts(int offset0, int offset1)
	{
		// start initialization
		outb(PIC1CMD, 0x11);
		outb(PIC2CMD, 0x11);
		outb(PIC1DAT, cast(ubyte) offset0); // master offset
		outb(PIC2DAT, cast(ubyte) offset1); // slave offset
		outb(PIC1DAT, 4); // slave@IRQ2
		outb(PIC2DAT, 2); // cascade
		// 8086 mode
		outb(PIC1DAT, 1);
		outb(PIC2DAT, 1);

		outb(PIC1DAT, 0xFF);
		outb(PIC2DAT, 0xFF);
	}

	void setIRQMask(ubyte IRQline)
	{
		ushort port;
		ubyte value;

		if (IRQline < 8)
		{
			port = PIC1DAT;
		}
		else
		{
			port = PIC2DAT;
			IRQline -= 8;
		}
		value = cast(ubyte)(inb(port) | (1 << IRQline));
		outb(port, value);
	}

	void clearIRQMask(ubyte IRQline)
	{
		ushort port;
		ubyte value;

		if (IRQline < 8)
		{
			port = PIC1DAT;
		}
		else
		{
			port = PIC2DAT;
			IRQline -= 8;
		}
		value = cast(ubyte)(inb(port) & ~(1 << IRQline));
		outb(port, value);
	}

	void disable()
	{
		asm nothrow @nogc
		{
			mov AL, 0xFF;
			out 0xA1, AL;
			out 0x21, AL;
		}
	}

}
