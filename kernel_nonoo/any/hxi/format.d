/// Simple formatted output
module hxi.format;

import kstdlib;

alias Writer = void delegate(dchar) @nogc nothrow;

nothrow:
@nogc:

private void writeSInt(scope Writer writer, long val)
{
	ulong v2;
	if (val < 0)
	{
		writer('-');
		v2 = -val;
	}
	else
	{
		v2 = val;
	}
	writeUInt(writer, v2);
}

private void writeUInt(scope Writer writer, ulong val)
{
	if (val == 0)
	{
		writer('0');
		return;
	}
	dchar[20] o;
	int p = 0;
	while (val > 0)
	{
		int dg = val % 10;
		o[p++] = dg + '0';
		val /= 10;
	}
	foreach_reverse (dchar ch; o[0 .. p])
	{
		writer(ch);
	}
}

private void writeXInt(scope Writer writer, ulong val)
{
	if (val == 0)
	{
		writer('0');
		return;
	}
	dchar[20] o;
	dstring chars = "0123456789ABCDEFGHIJ";
	int p = 0;
	while (val > 0)
	{
		int dg = val % 16;
		o[p++] = chars[dg];
		val /= 16;
	}
	foreach_reverse (dchar ch; o[0 .. p])
	{
		writer(ch);
	}
}

/**
Supported format specifiers:
%% - the '%' sign
%d - signed integer
%u - unsigned integer
%x - hex unsigned integer
%b - integer with units (B/KB/MB/TB)
%s - string
*/
void formattedWrite(Args...)(scope Writer writer, string fmtStr, Args args) @trusted
{
	ulong[args.length] largs;
	string[args.length] sargs;
	foreach (i, arg; Args)
	{
		static if (is(arg == string))
		{
			sargs[i] = args[i];
		}
		else
		{
			largs[i] = cast(ulong) args[i];
		}
	}
	bool percent = false;
	int argi = 0;
	foreach (dchar ch; fmtStr.byDchar)
	{
		if (percent)
		{
			percent = false;
			if (ch == '%')
			{
				writer('%');
				continue;
			}
			if (argi >= args.length)
			{
				writer('#');
				writer('L');
				writer('#');
				continue;
			}
			switch (ch)
			{
			case 'd':
				writeSInt(writer, cast(long) largs[argi++]);
				break;
			case 'u':
				writeUInt(writer, cast(ulong) largs[argi++]);
				break;
			case 'x':
				writeXInt(writer, cast(ulong) largs[argi++]);
				break;
			case 's':
				string str = sargs[argi++];
				foreach (dchar c; str.byDchar)
				{
					writer(c);
				}
				break;
			case 'b':
				ulong val = largs[argi++];
				if (val > 16.GB)
				{
					writeUInt(writer, val / 1.GB);
					writer('G');
					writer('B');
				}
				else if (val > 16.MB)
				{
					writeUInt(writer, val / 1.MB);
					writer('M');
					writer('B');
				}
				else if (val > 16.KB)
				{
					writeUInt(writer, val / 1.KB);
					writer('k');
					writer('B');
				}
				else
				{
					writeUInt(writer, val);
					writer('B');
				}
				break;
			default:
				writer('%');
				writer(ch);
				break;
			}
		}
		else
		{
			if (ch == '%')
			{
				percent = true;
				continue;
			}
			writer(ch);
		}
	}
}
