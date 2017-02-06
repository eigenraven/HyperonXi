/// Implementation of the RS232 driver for the x86 architecture
module hxi.cpu.rs232;

import kstdlib;
import asmutils;
public import hxi.obj.serialport;

immutable __gshared ushort[4] StandardPCSerialPortIDs = [0x3F8, 0x2F8, 0x3E8, 0x2E8];
immutable __gshared ubyte[4] StandardPCSerialPortIRQs = [4, 3, 4, 3];

enum ubyte PCSERIAL_OFFSET_DATA = 0;
enum ubyte PCSERIAL_OFFSET_LATCHLOW = 0;
enum ubyte PCSERIAL_OFFSET_INTERRUPTENABLE = 1;
enum ubyte PCSERIAL_OFFSET_LATCHHIGH = 1;
enum ubyte PCSERIAL_OFFSET_INTERRUPTID_FIFO = 2;
enum ubyte PCSERIAL_OFFSET_LINECONTROL = 3;
enum ubyte PCSERIAL_OFFSET_MODEMCONTROL = 4;
enum ubyte PCSERIAL_OFFSET_LINESTATUS = 5;
enum ubyte PCSERIAL_OFFSET_MODEMSTATUS = 6;
enum ubyte PCSERIAL_OFFSET_SCRATCH = 7;

//dfmt off
__gshared SerialPort.VTable RS232SerialPortVTable = SerialPort.VTable(
	&RS232SerialPort_Initialize,
	&RS232SerialPort_GetReadiness,
	&RS232SerialPort_SyncWriteData,
	&RS232SerialPort_SyncReadByte,
	&RS232SerialPort_HasByteToRead,
	&RS232SerialPort_HasSpaceToWrite,
	&RS232SerialPort_GetSupportedSpeeds,
	&RS232SerialPort_SetSpeed
);
//dfmt on

private:
nothrow:
@nogc:

bool transmitEmpty(int port)
{
	return (inb(cast(ushort)(port + PCSERIAL_OFFSET_LINESTATUS)) & 0x20) > 0;
}

bool receiveFull(int port)
{
	return (inb(cast(ushort)(port + PCSERIAL_OFFSET_LINESTATUS)) & 1) > 0;
}

extern (C):

ErrorCode RS232SerialPort_Initialize(SerialPort* this_)
{
	with (this_)
	{
		if (portId <= 0)
			return ErrorCode.DeviceNotReady;
		// disable interrupts
		outb(cast(ushort)(portId + PCSERIAL_OFFSET_INTERRUPTENABLE), 0x00);
		// 8 bits, no parity bit, one stop bit
		outb(cast(ushort)(portId + PCSERIAL_OFFSET_LINECONTROL), 0x03);
		// FIFO setup
		outb(cast(ushort)(portId + PCSERIAL_OFFSET_INTERRUPTID_FIFO), 0xC7);
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_GetReadiness(const(SerialPort)* this_, bool32* ready)
{
	with (this_)
	{
		*ready = ((portId > 0) && (speed > 0)) ? 1 : 0;
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_SyncWriteData(SerialPort* this_, usized dataLen, const(ubyte)* dataData)
{
	with (this_)
	{
		if (!((portId > 0) && (speed > 0)))
			return ErrorCode.DeviceNotReady;
		const(ubyte)[] data = dataData[0 .. dataLen];
		foreach (ubyte b; data)
		{
			while (!transmitEmpty(portId))
			{
				repnop();
			}
			io_wait();
			outb(cast(ushort) portId, b);
		}
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_SyncReadByte(SerialPort* this_, ubyte* data)
{
	with (this_)
	{
		if (!((portId > 0) && (speed > 0)))
			return ErrorCode.DeviceNotReady;
		while (!receiveFull(portId))
		{
			repnop();
		}
		io_wait();
		*data = inb(cast(ushort) portId);
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_HasByteToRead(SerialPort* this_, bool32* byteAvailable)
{
	with (this_)
	{
		if (!((portId > 0) && (speed > 0)))
			return ErrorCode.DeviceNotReady;
		*byteAvailable = receiveFull(portId) ? 1 : 0;
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_HasSpaceToWrite(SerialPort* this_, bool32* spaceAvailable)
{
	with (this_)
	{
		if (!((portId > 0) && (speed > 0)))
			return ErrorCode.DeviceNotReady;
		*spaceAvailable = transmitEmpty(portId) ? 1 : 0;
		return ErrorCode.NoError;
	}
}

immutable long[13] RS232Speeds = [
	50, 110, 220, 300, 600, 1200, 2400, 4800, 9600, 19_200, 38_400, 57_600, 115_200
];

ErrorCode RS232SerialPort_GetSupportedSpeeds(const(SerialPort)* this_,
		usized speedsLen, long* speedsData)
{
	with (this_)
	{
		long[] speeds = speedsData[0 .. speedsLen];
		if (speedsLen <= RS232Speeds.length)
		{
			speeds[] = RS232Speeds[0 .. speedsLen];
		}
		else
		{
			speeds[0 .. RS232Speeds.length] = RS232Speeds[];
			speeds[RS232Speeds.length .. $] = -1;
		}
		return ErrorCode.NoError;
	}
}

ErrorCode RS232SerialPort_SetSpeed(SerialPort* this_, const(long) newSpeed)
{
	with (this_)
	{
		if (!((portId > 0) && (speed > 0)))
			return ErrorCode.DeviceNotReady;
		bool found = false;
		foreach (long spd; RS232Speeds)
		{
			if (spd == newSpeed)
			{
				found = true;
				break;
			}
		}
		if (!found)
		{
			return ErrorCode.WrongEnumValue;
		}
		speed = newSpeed;
		int divisor = 115_200 / cast(int) newSpeed;
		ubyte divHigh = (divisor & 0xFF00) >> 8;
		ubyte divLow = divisor & 0xFF;
		ushort LCR = cast(ushort)(portId + PCSERIAL_OFFSET_LINECONTROL);
		// enable DLAB
		outb(LCR, inb(LCR) | 0x80);
		// push the divisor
		outb(cast(ushort)(portId + PCSERIAL_OFFSET_LATCHLOW), divLow);
		outb(cast(ushort)(portId + PCSERIAL_OFFSET_LATCHHIGH), divHigh);
		// disable DLAB
		outb(LCR, inb(LCR) & 0x7F);
		return ErrorCode.NoError;
	}
}

bool detectPortAt(ushort portId)
{
	ushort DAT = cast(ushort)(portId + PCSERIAL_OFFSET_DATA);
	ushort MCR = cast(ushort)(portId + PCSERIAL_OFFSET_MODEMCONTROL);
	ushort ICR = cast(ushort)(portId + PCSERIAL_OFFSET_INTERRUPTENABLE);
	// disable interrupts
	outb(ICR, 0);
	// enable loopback
	outb(MCR, 0x10);
	io_wait();
	// write some bytes and read them back
	bool ok = true;
	outb(DAT, 0x00);
	io_wait();
	ok &= (inb(DAT) == 0x00);
	outb(DAT, 0xAA);
	io_wait();
	ok &= (inb(DAT) == 0xAA);
	outb(DAT, 0xFF);
	io_wait();
	ok &= (inb(DAT) == 0xFF);
	//disable loopback
	outb(MCR, 0x0B);
	outb(DAT, ok ? 'V' : '-');
	return ok;
}

__gshared SerialPort debugPort = SerialPort(&RS232SerialPortVTable);

/// Returns null if a working port is not found
public SerialPort* trySetupDebugPort()
{
	foreach (stdport; StandardPCSerialPortIDs)
	{
		if (detectPortAt(stdport))
		{
			debugPort.portId = stdport;
			debugPort.speed = 50;
			debugPort.vtable.Initialize(&debugPort);
			debugPort.vtable.SetSpeed(&debugPort, RS232Speeds[$ - 1]);
			return &debugPort;
		}
	}
	return null;
}
