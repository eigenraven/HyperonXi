/// The 8042 PS/2 controller driver
module hxi.cpu.ps2;

import kstdlib;
import hxi.log;
import asmutils;

enum PS2DeviceType : ubyte
{
	Keyboard = 0xAB,
	Mouse2 = 0x00,
	Mouse3 = 0x03,
	Mouse5 = 0x04,
	NotConnected = 0xFF
}

string deviceTypeToString(PS2DeviceType t) nothrow @nogc @safe
{
	switch (t) with (PS2DeviceType)
	{
	case Keyboard:
		return "keyboard";
	case Mouse2:
		return "2-button mouse";
	case Mouse3:
		return "3-button mouse";
	case Mouse5:
		return "5-button mouse";
	case NotConnected:
		return "no device connected";
	default:
		return "unknown device";
	}
}

struct PS2Controller
{
	enum ushort DATA_PORT = 0x60;
	enum ushort STCMD_PORT = 0x64;
	__gshared bool isDualChannel, channel1Operational, channel2Operational;
	__gshared PS2DeviceType device1, device2;

nothrow:
@nogc:
static:

	void setup()
	{
		disableInterrupts();
		// disable devices
		outb(STCMD_PORT, 0xAD);
		io_wait();
		outb(STCMD_PORT, 0xA7);
		io_wait();
		// flush data
		flushBuffer();
		// update config
		writeCmd(0x20);
		ubyte cfg = readData();
		isDualChannel = (cfg & (1 << 5)) > 0;
		cfg &= 0xFF - 1 - 2 - 64;
		writeCmd(0x60);
		writeData(cfg);
		// self-test
		writeCmd(0xAA);
		if (readData() != 0x55)
		{
			log(LogLevel.Error, "PS/2 Self-test failed");
			return;
		}
		// test channels
		writeCmd(0xAB);
		ubyte s1 = readData(), s2 = 0xFF;
		channel1Operational = (s1 == 0);
		if (isDualChannel)
		{
			writeCmd(0xA9);
			s2 = readData();
			channel2Operational = (s2 == 0);
		}
		else
		{
			channel2Operational = false;
		}
		// enabling working devices
		if (channel1Operational)
		{
			writeCmd(0xAE);
			cfg |= 1;
		}
		if (channel2Operational)
		{
			writeCmd(0xA8);
			cfg |= 2;
		}
		// reset devices
		if (channel1Operational)
		{
			sendTo1(0xFF);
			ubyte response;
			do
			{
				response = readData();
			}
			while (response == 0xFA);
			logf(LogLevel.Trace, "Device 1 response: %x", cast(ulong) response);
			if (response != 0xAA)
			{
				channel1Operational = false;
			}
		}
		if (channel2Operational)
		{
			sendTo2(0xFF);
			ubyte response;
			do
			{
				response = readData();
			}
			while (response == 0xFA);
			logf(LogLevel.Trace, "Device 2 response: %x", cast(ulong) response);
			if (response != 0xAA)
			{
				channel2Operational = false;
			}
		}
		// clear buffer
		flushBuffer();
		// identify devices
		if (channel1Operational)
			device1 = identify(0);
		else
			device1 = PS2DeviceType.NotConnected;
		if (channel2Operational)
			device2 = identify(1);
		else
			device2 = PS2DeviceType.NotConnected;
		// print devices
		logf(LogLevel.Trace, "8042 PS/2 channels: %x[%s] %x[%s]", cast(ulong) device1,
				deviceTypeToString(device1), cast(ulong) device2, deviceTypeToString(device2));
		// find&configure keyboard
		int kb = -1;
		if (device1 == PS2DeviceType.Keyboard)
			kb = 0;
		else if (device2 == PS2DeviceType.Keyboard)
			kb = 1;
		if (kb >= 0)
		{
			sendTo(0xF5, kb); // disable scan
			readData();
			sendTo(0xF6, kb); // reset to defaults
			readData();

			sendTo(0xF0, kb); // scancode map 2
			readData();
			sendTo(0x02, kb);
			readData();

			sendTo(0xF3, kb); // typematic
			readData();
			sendTo(63, kb);
			readData();

			sendTo(0xED, kb); // LEDs
			readData();
			sendTo(0x00, kb);
			readData();

			do
			{
				sendTo(0xF4, kb); // enable scan
			}
			while (readData() != 0xFA);
		}
		int ms = -1;
		if (device1 <= PS2DeviceType.Mouse5)
			ms = 0;
		else if (device2 <= PS2DeviceType.Mouse5)
			ms = 1;
		if (ms >= 0)
		{
			sendTo(0xF4, ms); // enable raporting
			readData();
		}
		// reload cfg
		writeCmd(0x60);
		writeData(cfg);
		enableInterrupts();
		flushBuffer();
	}

	/// True when data present
	bool outputFull()
	{
		return (inb(STCMD_PORT) & 1) > 0;
	}

	/// False when ready to accept
	bool inputFull()
	{
		return (inb(STCMD_PORT) & 2) > 0;
	}

	ubyte readData()
	{
		foreach (i; 0 .. 10000)
		{
			if (outputFull())
				return inb(DATA_PORT);
			repnop();
		}
		return 0x00;
	}

	void writeData(ubyte dat)
	{
		while (inputFull())
		{
			repnop();
		}
		outb(DATA_PORT, dat);
	}

	void writeCmd(ubyte dat)
	{
		while (inputFull())
		{
			repnop();
		}
		outb(STCMD_PORT, dat);
	}

	void sendTo1(ubyte dat)
	{
		if (!channel1Operational)
			return;
		bool ready = false;
		foreach (i; 0 .. 10000)
		{
			ready = ready || !inputFull();
		}
		if (ready)
		{
			outb(DATA_PORT, dat);
		}
	}

	void sendTo2(ubyte dat)
	{
		if (!channel2Operational)
			return;
		outb(STCMD_PORT, 0xD4);
		bool ready = false;
		foreach (i; 0 .. 10000)
		{
			ready = ready || !inputFull();
		}
		if (ready)
		{
			outb(DATA_PORT, dat);
		}
	}

	void sendTo(ubyte dat, int device)
	{
		if (device == 0)
			sendTo1(dat);
		else
			sendTo2(dat);
	}

	void flushBuffer()
	{
		foreach (i; 0 .. 1000)
		{
			inb(DATA_PORT);
		}
	}

	PS2DeviceType identify(int device)
	{
		do
		{
			sendTo(0xF2, device);
		}
		while (readData() == 0xFE);
		ubyte T = readData();
		flushBuffer();
		return cast(PS2DeviceType) T;
	}

	void resetCPU()
	{
		writeCmd(0xFE);
	}
}
