module hxi.log;

import kstdlib;
import hxi.util;
public import hxi.obj.log;

private __gshared Logger*[16] loggersArray;

private immutable uint neutralColor = 0xFFFFFF;
private immutable uint[LogLevel.max + 1] loggingColors = [//dfmt off
	/*Trace*/ 0xBBBBBB,
	/*Info */ 0xCCCCFE,
	/*Warn */ 0xFEFE66,
	/*Error*/ 0xFE6666,
	/*Crit!*/ 0xFF0000
];                 //dfmt on
private immutable string[LogLevel.max + 1] loggingPrefixes = [//dfmt off
	/*Trace*/ ".trace. ",
	/*Info */ "[ info] ",
	/*Warn */ "[ Warn] ",
	/*Error*/ "[Error] ",
	/*Crit!*/ "[CRIT!] "
];                 //dfmt on

private extern (C) nothrow @nogc //
ErrorCode Log_Initialize(Log* this_)
{
	with (this_)
	{
		foreach (ref Logger* lgr; loggersArray)
		{
			lgr = null;
		}
		loggersLen = loggersArray.length;
		loggersData = loggersArray.ptr;
		level = LogLevel.Trace;
		return ErrorCode.NoError;
	}
}

private extern (C) nothrow @nogc //
ErrorCode Log_AddLogger(Log* this_, Logger* logger)
{
	with (this_)
	{
		//TODO:Lock
		foreach (i; 0 .. loggersLen)
		{
			if (loggersData[i] is null)
			{
				loggersData[i] = logger;
				logger.id = cast(int) i;
				return ErrorCode.NoError;
			}
		}
		return ErrorCode.OutOfPreallocatedMemory;
	}
}

private extern (C) nothrow @nogc //
ErrorCode Log_RemoveLogger(Log* this_, Logger* logger)
{
	with (this_)
	{
		//TODO:Lock
		int i = logger.id;
		if (!inRange(i, 0, cast(int) loggersLen))
			return ErrorCode.NotFound;
		if (loggersData[i] is logger)
		{
			loggersData[i] = null;
			logger.id = -1;
			return ErrorCode.NoError;
		}
		return ErrorCode.NotFound;
	}
}

private extern (C) nothrow @nogc //
ErrorCode Log_SetLevel(Log* this_, const(LogLevel) targetLevel)
{
	with (this_)
	{
		if (!validEnumValue!LogLevel(targetLevel))
			return ErrorCode.WrongEnumValue;
		level = targetLevel;
		return ErrorCode.NoError;
	}
}

private extern (C) nothrow @nogc //
ErrorCode Log_GetLevel(const(Log)* this_, LogLevel* targetLevel)
{
	with (this_)
	{
		if (targetLevel is null)
			return ErrorCode.NullPointer;
		*targetLevel = level;
		return ErrorCode.NoError;
	}
}

private extern (C) nothrow @nogc //
ErrorCode Log_Output(Log* this_, const(LogLevel) msgLevel, usized messageLen,
		const(ubyte)* messageData)
{
	with (this_)
	{
		const(ubyte)[] message = messageData[0 .. messageLen];
		if (msgLevel < level)
		{
			return ErrorCode.NoError;
		}
		if (!validEnumValue!LogLevel(msgLevel))
			return ErrorCode.WrongEnumValue;
		if (!validUTF8(message))
			return ErrorCode.MalformedString;
		//TODO:Lock ?
		foreach (Logger* lg; loggersData[0 .. loggersLen])
		{
			if (lg !is null)
			{
				lg.vtable.SetColor(lg, loggingColors[msgLevel]);
				lg.vtable.OutputText(lg, loggingPrefixes[level].length,
						cast(ubyte*) loggingPrefixes[level].ptr);
				lg.vtable.OutputText(lg, messageLen, messageData);
				lg.vtable.SetColor(lg, neutralColor);
			}
		}
		return ErrorCode.NoError;
	}
}

private __gshared Log.VTable LogVTable = Log.VTable( //
		&Log_Initialize, //
		&Log_AddLogger, //
		&Log_RemoveLogger, //
		&Log_SetLevel, //
		&Log_GetLevel, //
		&Log_Output);

__gshared Log TheLog = Log(&LogVTable);
