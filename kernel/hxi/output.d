/// Debugging&logging output for the kernel
module hxi.output;

import hxi.fbcon.textbuffer;
import hxi.drivers.serial;

nothrow:
@nogc:

enum LogLevel : int
{
    Trace = 0,
    Info,
    Warn,
    Error
}

private __gshared TextFramebuffer* kernelOutputFb;
__gshared LogLevel kernelLogLevel = LogLevel.Trace;

void setLoggingOutputFramebuffer(TextFramebuffer* fb)
{
    kernelOutputFb = fb;
}

TextFramebuffer* getLoggingOutputFramebuffer()
{
    return kernelOutputFb;
}

private void putColorString(uint color, const(wchar)[] text)
{
    foreach (ch; text)
    {
        debugPort.writeByte(cast(ubyte) ch);
        if (ch >= 256)
        {
            debugPort.writeByte(cast(ubyte)(ch >> 8));
        }
    }
    if (kernelOutputFb !is null)
    {
        CharAttributes a = colorChar(color);
        kernelOutputFb.printStringAttr(text, a);
    }
}

private bool beginLogMsg(LogLevel ll, uint* msgColor)
{
    //if (ll < kernelLogLevel)
    //    return false;
    uint color;
    wchar[7] pfx;
    switch (ll)
    {
    case LogLevel.Trace:
        color = 0xDDDDDD;
        *msgColor = 0xDDDDDD;
        pfx = " trace "w;
        break;
    case LogLevel.Info:
        color = 0xBBBBEF;
        pfx = "  info "w;
        *msgColor = 0xE0E0FF;
        break;
    case LogLevel.Warn:
        color = 0xEEEE11;
        pfx = "  warn "w;
        *msgColor = 0xFFFFE0;
        break;
    case LogLevel.Error:
        color = 0xEE1111;
        pfx = " error "w;
        *msgColor = 0xFFE0E0;
        break;
    default:
        color = 0x1111FF;
        *msgColor = 0xFFFFFF;
        pfx = " ????? "w;
        break;
    }
    putColorString(0xFFFFFF, "[");
    putColorString(color, pfx);
    putColorString(0xFFFFFF, "] ");
    return true;
}

void log(LogLevel ll, const(wchar)[] msg)
{
    uint color;
    if (beginLogMsg(ll, &color))
    {
        putColorString(color, msg);
        putColorString(color, "\n");
    }
}
