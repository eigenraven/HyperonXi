module hxi.serial;

import kstdlib;
import asmutils;

///
__gshared SerialPort debugPort_;
///
ref SerialPort debugPort() @trusted nothrow @nogc
{
	return debugPort_;
}

struct SerialPort
{
	/// IO Port
	ushort port;

nothrow:
@nogc:

	void initialize() @trusted
	{
		outb(cast(ushort)(port + 1), cast(ubyte) 0x00); // Disable all interrupts
		outb(cast(ushort)(port + 3), cast(ubyte) 0x80); // Enable DLAB (set baud rate divisor)
		outb(cast(ushort)(port + 0), cast(ubyte) 0x01); // Set divisor to 1 (lo byte) 115200 baud
		outb(cast(ushort)(port + 1), cast(ubyte) 0x00); //                  (hi byte)
		outb(cast(ushort)(port + 3), cast(ubyte) 0x03); // 8 bits, no parity, one stop bit
		outb(cast(ushort)(port + 2), cast(ubyte) 0xC7); // Enable FIFO, clear them, with 14-byte threshold
		outb(cast(ushort)(port + 4), cast(ubyte) 0x0B); // IRQs enabled, RTS/DSR set
	}

	bool isTransmitBufferEmpty() @trusted
	{
		return (inb(cast(ushort)(port + 5)) & 0x20) > 0;
	}

	void writeByte(ubyte a) @trusted
	{
		while (!isTransmitBufferEmpty())
		{
		}
		outb(port, a);
	}

	void writeBytes(const(ubyte)[] bytes) @safe
	{
		foreach (ubyte b; bytes)
			writeByte(b);
	}

	void writeString(const(char)[] str) @safe
	{
		foreach (char b; str)
			writeByte(cast(ubyte) b);
	}

	void writeStringLn(const(char)[] str) @safe
	{
		writeString(str);
		writeByte('\n');
	}

	void writeSLong(long num) @safe
	{
		ulong unum;
		if (num < 0)
		{
			writeByte('-');
			unum = -num;
		}
		else
			unum = num;
		char[16] digits = "0123456789ABCDEF";
		writeByte('0');
		writeByte('x');
		long pshift = 60;
		while (pshift >= 0)
		{
			writeByte(digits[(unum >> pshift) & 0xF]);
			pshift -= 4;
		}
	}

	void writeULong(ulong unum) @safe
	{
		char[16] digits = "0123456789ABCDEF";
		writeByte('0');
		writeByte('x');
		long pshift = 60;
		while (pshift >= 0)
		{
			writeByte(digits[(unum >> pshift) & 0xF]);
			pshift -= 4;
		}
	}

}

private extern (C) void printToDebugPort(void* data, dchar chr) nothrow @nogc @safe
{
	cast(void) data;
	if (debugPort.port == 0)
		return;
	if (chr == '\n')
		debugPort.writeByte('\r');
	debugPort.writeByte(chr & 0xFFu);
}

///
void setupSerialDebugPort() @safe nothrow @nogc
{
	debugPort = SerialPort(0x3F8);
	debugPort.initialize();

	import hxi.log : registerLogger, LogHandlerType, LogHandlerEntry;

	//registerLogger(LogHandlerEntry(null, &printToDebugPort, null, LogHandlerType.PlainText));
}
