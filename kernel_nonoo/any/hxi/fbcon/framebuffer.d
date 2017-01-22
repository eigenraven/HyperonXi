module hxi.fbcon.framebuffer;

import kstdlib;
import multiboot;
public import hxi.fbcon.types;
import hxi.log;
import hxi.mem.memory;
import hxi.mem.paging;
import hxi.mem.virtual_allocator;
import hxi.fbcon.font_data;
import hxi.fbcon.font_import : confont_charcount, confont_charheight,
	confont_charwidth;
import hxi.fbcon.gfxfont;

struct FbFormat
{
	uint bytesPerPixel;
	uint redShift;
	uint greenShift;
	uint blueShift;
}

/// Framebuffer character
struct FbChar
{
	wchar ch;
	uint foreground;
	uint background;
}

__gshared Framebuffer* activeFramebuffer;

struct Framebuffer
{
	bool active = true;
	int width;
	int height;
	int pitch;
	FbFormat format;
	ubyte* pixels;
	FbChar[] textBuffer;
	int textWidth, textHeight;
	int cursorX, cursorY;
	uint colorForeground, colorBackground;
	LogHandlerId lhi;
nothrow:
@nogc:
	private static extern (C) void logHandler(void* data, dchar ch) @trusted
	{
		Framebuffer* fb = cast(Framebuffer*) data;
		fb.printChar(ch);
	}

	private static extern (C) void logfmtHandler(void* data, uint rgb) @trusted
	{
		Framebuffer* fb = cast(Framebuffer*) data;
		fb.colorForeground = rgb;
		fb.colorBackground = 0;
	}

	/// Constructor taking a multiboot2 standard framebuffer description
	this(multiboot_tag_framebuffer* mbData)
	{
		active = true;
		activeFramebuffer = &this;
		width = mbData.common.framebuffer_width;
		height = mbData.common.framebuffer_height;
		pitch = mbData.common.framebuffer_pitch;
		pixels = physicalSpaceToPhmap!ubyte(PhysicalAddress(mbData.common.framebuffer_addr));
		PageTable.current.updateEntryRange(PageSize.Size4k, PageFlags.KernelRW, pixels,
				pixels + pitch * height, PhysicalAddress(mbData.common.framebuffer_addr));
		if (mbData.common.framebuffer_type != MULTIBOOT_FRAMEBUFFER_TYPE_RGB)
		{
			log(LogLevel.Error, "Unsupported framebuffer format");
		}
		format.bytesPerPixel = mbData.common.framebuffer_bpp / 8;
		format.redShift = mbData.framebuffer_red_field_position / 8;
		format.greenShift = mbData.framebuffer_green_field_position / 8;
		format.blueShift = mbData.framebuffer_blue_field_position / 8;
		foreach (i; 0 .. pitch * height)
		{
			pixels[i] = 0;
		}
		// text buffer initialization
		textWidth = (width - 2) / confont_charwidth;
		textHeight = (height - 2) / confont_charheight;
		cursorX = 0;
		cursorY = 0;
		textBuffer = (cast(FbChar*) KernelVirtualMemoryAllocator.allocatePages(
				cast(uint)(textWidth * textHeight * FbChar.sizeof / PAGE_GRANULARITY)))[0
			.. textWidth * textHeight];
		colorForeground = 0xFFFFFF;
		colorBackground = 0x000000;

		// log handler initialization
		LogHandlerEntry lhe;
		lhe.data = &this;
		lhe.type = LogHandlerType.FormattedText;
		lhe.log = &logHandler;
		lhe.logFormat = &logfmtHandler;
		lhi = registerLogger(lhe);
	}

	~this()
	{
		unregisterLogger(lhi);
		KernelVirtualMemoryAllocator.freePages(cast(void*) textBuffer.ptr,
				cast(uint)(textWidth * textHeight * FbChar.sizeof / PAGE_GRANULARITY));
	}

	/// Color = 0xRRGGBB
	void clear(uint color)
	{
		ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
		ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
		ubyte b = cast(ubyte)((color & 0x0000FF));
		foreach (row; 0 .. height)
		{
			foreach (column; 0 .. width)
			{
				size_t addr = row * pitch + (column * format.bytesPerPixel);
				pixels[addr + format.redShift] = r;
				pixels[addr + format.greenShift] = g;
				pixels[addr + format.blueShift] = b;
			}
		}
	}

	void clearText()
	{
		cursorX = 0;
		cursorY = 0;
		foreach (ref FbChar chr; textBuffer)
		{
			chr.ch = '\0';
			chr.background = 0;
			chr.foreground = 0xFFFFFF;
		}
		clear(0);
	}

	void drawMonoBitmap(FbMonoBitmap bmp, int dstX, int dstY, int color,
			int bgcolor = -1, int srcX = 0, int srcY = 0, int srcW = int.max, int srcH = int.max)
	{
		ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
		ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
		ubyte b = cast(ubyte)(color & 0x0000FF);
		ubyte R = cast(ubyte)((bgcolor & 0xFF0000) >> 16);
		ubyte G = cast(ubyte)((bgcolor & 0x00FF00) >> 8);
		ubyte B = cast(ubyte)(bgcolor & 0x0000FF);
		if (srcW > bmp.w)
			srcW = bmp.w;
		if (srcH > bmp.h)
			srcH = bmp.h;
		int lim_y = dstY + bmp.h;
		int lim_x = dstX + bmp.w;
		if (lim_y > height)
			lim_y = height;
		if (lim_x > width)
			lim_x = width;
		int stride = bmp.w / 8;
		for (int dy = dstY, sy = srcY; dy < lim_y; dy++, sy++)
		{
			for (int dx = dstX, sx = srcX; dx < lim_x; dx++, sx++)
			{
				ubyte pix = bmp.bytes[stride * sy + (sx >> 3)] & (1 << (sx & 7));
				size_t addr = dy * pitch + (dx * format.bytesPerPixel);
				if (pix)
				{
					pixels[addr + format.redShift] = r;
					pixels[addr + format.greenShift] = g;
					pixels[addr + format.blueShift] = b;
				}
				else if (bgcolor >= 0)
				{
					pixels[addr + format.redShift] = R;
					pixels[addr + format.greenShift] = G;
					pixels[addr + format.blueShift] = B;
				}
			}
		}
	}

	void drawRMonoBitmap(FbMonoBitmap bmp, int dstX, int dstY, int color,
			int bgcolor = -1, int srcX = 0, int srcY = 0, int srcW = int.max, int srcH = int.max)
	{
		ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
		ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
		ubyte b = cast(ubyte)(color & 0x0000FF);
		ubyte R = cast(ubyte)((bgcolor & 0xFF0000) >> 16);
		ubyte G = cast(ubyte)((bgcolor & 0x00FF00) >> 8);
		ubyte B = cast(ubyte)(bgcolor & 0x0000FF);
		if (srcW > bmp.w)
			srcW = bmp.w;
		if (srcH > bmp.h)
			srcH = bmp.h;
		int lim_y = dstY + bmp.h;
		int lim_x = dstX + bmp.w;
		if (lim_y > height)
			lim_y = height;
		if (lim_x > width)
			lim_x = width;
		int stride = bmp.w / 8;
		for (int dy = dstY, sy = srcY; dy < lim_y; dy++, sy++)
		{
			for (int dx = dstX, sx = srcX; dx < lim_x; dx++, sx++)
			{
				ubyte pix = bmp.bytes[stride * sy + (sx >> 3)] & (1 << (7 - (sx & 7)));
				size_t addr = dy * pitch + (dx * format.bytesPerPixel);
				if (pix)
				{
					pixels[addr + format.redShift] = r;
					pixels[addr + format.greenShift] = g;
					pixels[addr + format.blueShift] = b;
				}
				else if (bgcolor >= 0)
				{
					pixels[addr + format.redShift] = R;
					pixels[addr + format.greenShift] = G;
					pixels[addr + format.blueShift] = B;
				}
			}
		}
	}

	void drawFilledRect(int color, int x, int y, int w, int h)
	{
		ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
		ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
		ubyte b = cast(ubyte)(color & 0x0000FF);
		if (x < 0)
			x = 0;
		if (y < 0)
			y = 0;
		int xlim = x + w;
		int ylim = y + h;
		if (xlim > width)
			xlim = width;
		if (ylim > height)
			ylim = height;
		for (int irow = y; irow < ylim; irow++)
		{
			for (int icol = x; icol < xlim; icol++)
			{
				size_t addr = irow * pitch + (icol * format.bytesPerPixel);
				pixels[addr + format.redShift] = r;
				pixels[addr + format.greenShift] = g;
				pixels[addr + format.blueShift] = b;
			}
		}
	}

	void invertRect(int x, int y, int w, int h)
	{
		if (x < 0)
			x = 0;
		if (y < 0)
			y = 0;
		uint xlim = x + w;
		uint ylim = y + h;
		if (xlim < width)
			xlim = width;
		if (ylim < height)
			ylim = height;
		foreach (row; y .. ylim)
		{
			foreach (col; x .. xlim)
			{
				size_t addr = row * pitch + (col * format.bytesPerPixel);
				pixels[addr + format.redShift] = cast(ubyte)(255 - pixels[addr + format.redShift]);
				pixels[addr + format.greenShift] = cast(ubyte)(255 - pixels[addr + format
						.greenShift]);
				pixels[addr + format.blueShift] = cast(ubyte)(255 - pixels[addr + format.blueShift]);
			}
		}
	}

	void redrawText()
	{
		if (!active)
			return;
		clear(0);
		foreach (row; 0 .. textHeight)
		{
			foreach (col; 0 .. textWidth)
			{
				drawCell(row, col);
			}
		}
	}

	void drawCell(int row, int col)
	{
		// bg
		FbChar chr = textBuffer[col + row * textWidth];
		// fg
		if (textBuffer[col + row * textWidth].ch != '\0')
		{
			FbMonoBitmap bmp = getCharBitmap(textBuffer[col + row * textWidth].ch);
			drawRMonoBitmap(bmp, 1 + col * confont_charwidth,
					1 + row * confont_charheight, chr.foreground, chr.background);
		}
	}

	void scrollUp(int lines)
	{
		foreach (row; 0 .. textHeight - lines)
		{
			int orow = row + lines;
			foreach (col; 0 .. textWidth)
			{
				textBuffer[col + textWidth * row] = textBuffer[col + textWidth * orow];
			}
		}
		foreach (row; textHeight - lines .. textHeight)
		{
			foreach (col; 0 .. textWidth)
			{
				textBuffer[col + textWidth * row].ch = '\0';
			}
		}
		cursorY -= lines;
		if (cursorY < 0)
			cursorY = 0;
		redrawText();
	}

	void cursorNext(dchar ch)
	{
		int cw = getCharBitmap(ch).w / confont_charwidth;
		cursorX += cw;
		if (cursorX >= textWidth)
		{
			cursorX = 0;
			cursorY++;
			if (cursorY >= textHeight)
			{
				scrollUp(1);
			}
		}
	}

	/// Warning: due to limited font support, ch is stripped to 16 bits!
	void printChar(dchar ch)
	{
		switch (ch)
		{
		case '\n':
			cursorX = textWidth;
			cursorNext('a');
			break;
		case '\r':
			cursorX = -1;
			cursorNext('a');
			break;
		default:
			textBuffer[cursorX + cursorY * textWidth] = FbChar(cast(wchar) ch,
					colorForeground, colorBackground);
			drawCell(cursorY, cursorX);
			cursorNext(ch);
			break;
		}
	}

	void printString(string str)
	{
		foreach (dchar chr; str.byDchar())
		{
			printChar(chr);
		}
	}

	ref uint background()
	{
		return colorBackground;
	}

	ref uint foreground()
	{
		return colorForeground;
	}

}
