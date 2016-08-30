module hxi.fbcon.textbuffer;

import barec;
import hxi.fbcon.types;
import hxi.fbcon.font_import;
import hxi.fbcon.gfxfont;
import hxi.fbcon.framebuffer;

enum CharAttributes : ushort
{
    Default = 0xFFFE,
    Bold = 0x1
}

/// color == 0xRRGGBB
CharAttributes colorChar(uint color) nothrow @nogc
{
    ubyte r = (color >> 16) & 0xFF;
    ubyte g = (color >> 8) & 0xFF;
    ubyte b = color & 0xFF;
    r = cast(ubyte)(r * MemoryTextBuffer.colorMask / 0xFF);
    g = cast(ubyte)(g * MemoryTextBuffer.colorMask / 0xFF);
    b = cast(ubyte)(b * MemoryTextBuffer.colorMask / 0xFF);
    ushort outp;
    outp |= r << MemoryTextBuffer.redShift;
    outp |= g << MemoryTextBuffer.greenShift;
    outp |= b << MemoryTextBuffer.blueShift;
    return cast(CharAttributes) outp;
}

private struct MemoryTextBuffer
{
    enum ushort boldMask = 1;
    enum ushort colorMask = 0x1F;
    enum ushort colorsMask = 0xFFFE;
    enum ushort redShift = 1;
    enum ushort greenShift = 6;
    enum ushort blueShift = 11;
    wchar txt;
    ushort colorAndFlags; /// 555 RGB, 1 Bold/Invert
}

struct TextFramebuffer
{
    Framebuffer* driver;
    MemoryTextBuffer[] textBuffer;
    int width, height;
    int curX, curY;
    ushort cursorHeight;

nothrow:
@nogc:

    void initialize(Framebuffer* dvr)
    {
        driver = dvr;
        width = (driver.width - 2) / confont_charwidth;
        height = (driver.height - 2) / confont_charheight;
        curX = 0;
        curY = 0;
        cursorHeight = 1;
        textBuffer = (cast(MemoryTextBuffer*) kcalloc(width * height, MemoryTextBuffer.sizeof))[0
            .. width * height];
    }

    void destroy()
    {
        kfree(textBuffer.ptr);
    }

    void redraw()
    {
        if (!driver.active)
            return;
        driver.clear(0);
        foreach (row; 0 .. height)
        {
            foreach (col; 0 .. width)
            {
                drawCell(row, col);
            }
        }
    }

    void drawCell(int row, int col)
    {
        // bg
        ushort cf = textBuffer[col + row * width].colorAndFlags;
        ubyte r = (cf >> MemoryTextBuffer.redShift) & MemoryTextBuffer.colorMask;
        ubyte g = (cf >> MemoryTextBuffer.greenShift) & MemoryTextBuffer.colorMask;
        ubyte b = (cf >> MemoryTextBuffer.blueShift) & MemoryTextBuffer.colorMask;
        r = cast(ubyte)(r * 255 / MemoryTextBuffer.colorMask);
        g = cast(ubyte)(g * 255 / MemoryTextBuffer.colorMask);
        b = cast(ubyte)(b * 255 / MemoryTextBuffer.colorMask);
        int color = (r << 16) + (g << 8) + b;
        if (cf & MemoryTextBuffer.boldMask) // fg
        {
            driver.drawFilledRect(color, 1 + col * confont_charwidth,
                    1 + row * confont_charheight, confont_charwidth, confont_charheight);
            color = 0xFFFFFF - color;
        }
        if (textBuffer[col + row * width].txt != '\0')
        {
            FbMonoBitmap bmp = getCharBitmap(textBuffer[col + row * width].txt);
            driver.drawRMonoBitmap(bmp, 1 + col * confont_charwidth,
                    1 + row * confont_charheight, color);
        }
    }

    void scrollUp(int lines)
    {
        foreach (row; 0 .. height - lines)
        {
            int orow = row + lines;
            foreach (col; 0 .. width)
            {
                textBuffer[col + width * row] = textBuffer[col + width * orow];
            }
        }
        foreach (row; height - lines .. height)
        {
            foreach (col; 0 .. width)
            {
                textBuffer[col + width * row] = MemoryTextBuffer('\0', CharAttributes.Default);
            }
        }
        curY -= lines;
        if (curY < 0)
            curY = 0;
        redraw();
    }

    void cursorNext(dchar ch)
    {
        int cw = getCharBitmap(ch).w / confont_charwidth;
        curX += cw;
        if (curX >= width)
        {
            curX = 0;
            curY++;
            if (curY >= height)
            {
                scrollUp(1);
            }
        }
    }

    void printChar(dchar ch, ushort attribs = CharAttributes.Default)
    {
        switch (ch)
        {
        case '\n':
            curX = width;
            cursorNext('a');
            break;
        case '\r':
            curX = -1;
            cursorNext('a');
            break;
        default:
            textBuffer[curX + curY * width] = MemoryTextBuffer(cast(wchar) ch, attribs);
            drawCell(curY, curX);
            cursorNext(ch);
            break;
        }
    }

    void printStringAttr(Char)(const(Char)[] str, ushort attribs = CharAttributes.Default)
            if (is(Char == char) || is(Char == wchar) || is(Char == dchar))
    {
        foreach (chr; str)
        {
            printChar(chr, attribs);
        }
    }

    void printULong(ulong unum, ushort attribs = CharAttributes.Default)
    {
        char[16] digits = "0123456789ABCDEF";
        printChar('0', attribs);
        printChar('x', attribs);
        long pshift = 60;
        while (pshift >= 0)
        {
            printChar(digits[(unum >> pshift) & 0xF], attribs);
            pshift -= 4;
        }
    }

}
