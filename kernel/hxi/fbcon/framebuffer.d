module hxi.fbcon.framebuffer;

import barec;
import hxi.multiboot;
public import hxi.fbcon.types;
import hxi.output;

struct FbFormat
{
    uint bytesPerPixel;
    uint redShift;
    uint greenShift;
    uint blueShift;
}

struct Framebuffer
{
    bool active = true;
    int width;
    int height;
    int pitch;
    FbFormat format;
    ubyte* pixels;
nothrow:
@nogc:

    this(multiboot_tag_framebuffer* mbData)
    {
        import hxi.memory.paging;

        active = true;
        width = mbData.common.framebuffer_width;
        height = mbData.common.framebuffer_height;
        pitch = mbData.common.framebuffer_pitch;
        pixels = cast(ubyte*) mbData.common.framebuffer_addr;
        if (mbData.common.framebuffer_type != MULTIBOOT_FRAMEBUFFER_TYPE_RGB)
        {
            log(LogLevel.Error, "Unsupported framebuffer format");
            //debugPort.writeULong(mbData.common.framebuffer_type);
        }
        format.bytesPerPixel = mbData.common.framebuffer_bpp / 8;
        format.redShift = mbData.framebuffer_red_field_position / 8;
        format.greenShift = mbData.framebuffer_green_field_position / 8;
        format.blueShift = mbData.framebuffer_blue_field_position / 8;
        //TODO:LOG:Init
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

    void drawMonoBitmap(FbMonoBitmap bmp, int dstX, int dstY, int color,
            int srcX = 0, int srcY = 0, int srcW = int.max, int srcH = int.max)
    {
        ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
        ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
        ubyte b = cast(ubyte)((color & 0x0000FF));
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
                if (pix)
                {
                    size_t addr = dy * pitch + (dx * format.bytesPerPixel);
                    pixels[addr + format.redShift] = r;
                    pixels[addr + format.greenShift] = g;
                    pixels[addr + format.blueShift] = b;
                }
            }
        }
    }

    void drawRMonoBitmap(FbMonoBitmap bmp, int dstX, int dstY, int color,
            int srcX = 0, int srcY = 0, int srcW = int.max, int srcH = int.max)
    {
        ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
        ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
        ubyte b = cast(ubyte)((color & 0x0000FF));
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
                if (pix)
                {
                    size_t addr = dy * pitch + (dx * format.bytesPerPixel);
                    pixels[addr + format.redShift] = r;
                    pixels[addr + format.greenShift] = g;
                    pixels[addr + format.blueShift] = b;
                }
            }
        }
    }

    void drawFilledRect(int color, int x, int y, int w, int h)
    {
        ubyte r = cast(ubyte)((color & 0xFF0000) >> 16);
        ubyte g = cast(ubyte)((color & 0x00FF00) >> 8);
        ubyte b = cast(ubyte)((color & 0x0000FF));
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
                size_t addr = row * pitch + (row * format.bytesPerPixel);
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
                size_t addr = row * pitch + (row * format.bytesPerPixel);
                pixels[addr + format.redShift] = cast(ubyte)(255 - pixels[addr + format.redShift]);
                pixels[addr + format.greenShift] = cast(ubyte)(255 - pixels[addr + format
                        .greenShift]);
                pixels[addr + format.blueShift] = cast(ubyte)(255 - pixels[addr + format.blueShift]);
            }
        }
    }
}
