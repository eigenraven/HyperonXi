/// Kernel logging and error reporting module.
module hxi.log;

import kstdlib;
import hxi.format;

nothrow:
@nogc:
@safe:

///
alias LogHandlerId = Typedef!(short, -1, "loghandler");

extern (C)
{
	/// Called to print a single character.
	alias LogHandler = void function(void*, dchar) nothrow @nogc @safe;
	/// Called to change current text color.
	alias LogFormatHandler = void function(void*, uint rgb) nothrow @nogc @safe;
}

///
enum LogHandlerType : ubyte
{
	Null = 0,
	PlainText,
	FormattedText
}

///
struct LogHandlerEntry
{
	/// Additional data passed to the log functions
	void* data = null;
	///
	LogHandler log = null;
	///
	LogFormatHandler logFormat = null;
	///
	LogHandlerType type = LogHandlerType.Null;
}

__gshared LogHandlerEntry[16] loggers_;

///
LogHandlerEntry[] loggers() @trusted
{
	return loggers_;
}

///
enum LogLevel : ushort
{
	Trace = 16,
	Info,
	Warn,
	Error,
	Critical
}

__gshared LogLevel logLevel_;
///
ref LogLevel logLevel() @trusted
{
	return logLevel_;
}

///
void setupLogging()
{
	foreach (ref handler; loggers)
	{
		handler = LogHandlerEntry();
	}
	logLevel = LogLevel.Trace;
}

///
LogHandlerId registerLogger(LogHandlerEntry entry)
{
	foreach (i, ref h; loggers)
	{
		if (h.type == LogHandlerType.Null)
		{
			h = entry;
			return LogHandlerId(cast(ushort) i);
		}
	}
	return LogHandlerId();
}

///
void unregisterLogger(LogHandlerId id)
{
	if ((id < 0) || (id >= loggers.length))
	{
		return;
	}
	loggers[cast(ushort) id] = LogHandlerEntry();
}

private void setLogLevelColor(LogLevel l)
{
	uint col;
	switch (l) with (LogLevel)
	{
	case Trace:
		col = 0xaaaaaa;
		break;
	case Info:
		col = 0xeeeeee;
		break;
	case Warn:
		col = 0xeeee77;
		break;
	case Error:
		col = 0xee7777;
		break;
	case Critical:
		col = 0xff0000;
		break;
	default:
		col = 0xeeeeee;
		break;
	}
	foreach (ref h; loggers)
	{
		if ((h.type == LogHandlerType.FormattedText) && (h.logFormat !is null))
		{
			h.logFormat(h.data, col);
		}
	}
}

private void putlogch(dchar ch)
{
	foreach (ref h; loggers)
	{
		if ((h.type != LogHandlerType.Null) && (h.log !is null))
		{
			h.log(h.data, ch);
		}
	}
}

private void putlogstr(string s)
{
	foreach (ref h; loggers)
	{
		if ((h.type != LogHandlerType.Null) && (h.log !is null))
		{
			foreach (dchar ch; s.byDchar)
				h.log(h.data, ch);
		}
	}
}

private bool startLogLevel(LogLevel lvl)
{
	if (lvl < logLevel)
		return false;
	setLogLevelColor(LogLevel.Info);
	putlogch('[');
	setLogLevelColor(lvl);
	switch (lvl) with (LogLevel)
	{
	case Trace:
		putlogstr("trac");
		break;
	case Info:
		putlogstr("info");
		break;
	case Warn:
		putlogstr("Warn");
		break;
	case Error:
		putlogstr("ERR!");
		break;
	case Critical:
		putlogstr("CRT!");
		break;
	default:
		putlogstr("????");
		break;
	}
	setLogLevelColor(LogLevel.Info);
	putlogstr("] ");
	return true;
}

///
void log(LogLevel lvl, string msg)
{
	if (!startLogLevel(lvl))
		return;
	putlogstr(msg);
	putlogch('\n');
}

void logf(Args...)(LogLevel lvl, string fmt, Args args)
{
	if (!startLogLevel(lvl))
		return;
	formattedWrite!Args((dchar ch) { putlogch(ch); }, fmt, args);
	putlogch('\n');
}
