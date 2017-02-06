/// Logger implemented using a serial debug port.
module hxi.cpu.rs232logger;

import kstdlib;
import hxi.obj.serialport;
import hxi.cpu.rs232;
import hxi.log;

@CurrentVersion(1)
struct RS232DebugLogger
{
	@MinimumVersion(1)
	Logger parent;
	@MinimumVersion(1)
	SerialPort* port;

	alias parent this;
}

nothrow:
@nogc:

// tries to setup debug logging if possible.
Logger* setupDebugLogging(Kernel* krnl)
{
	SerialPort* port = trySetupDebugPort();
	if (port !is null)
	{
		import asmutils : outb;

		RS232DebugLoggerInstance.port = port;
		krnl.log.vtable.AddLogger(krnl.log, &RS232DebugLoggerInstance.parent);
		return &RS232DebugLoggerInstance.parent;
	}
	return null;
}

private:
extern (C):

// dfmt off
__gshared RS232DebugLogger.VTable RS232DebugLoggerVTable = RS232DebugLogger.VTable(
	&RS232DebugLogger_SetColor,
	&RS232DebugLogger_OutputText);
// dfmt on

__gshared RS232DebugLogger RS232DebugLoggerInstance = RS232DebugLogger(
		Logger(&RS232DebugLoggerVTable));

ErrorCode RS232DebugLogger_SetColor(Logger* this_, const(uint) newColor)
{
	// no-op
	return ErrorCode.NoError;
}

ErrorCode RS232DebugLogger_OutputText(Logger* this_, usized textLen, const(ubyte)* textData)
{
	RS232DebugLogger* ths_ = cast(RS232DebugLogger*) this_;
	ths_.port.vtable.SyncWriteData(ths_.port, textLen, textData);
	return ErrorCode.NoError;
}
