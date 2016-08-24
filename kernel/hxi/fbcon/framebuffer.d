module hxi.fbcon.framebuffer;

import barec;
import hxi.drivers.serial;
import hxi.multiboot;
public import hxi.fbcon.types;

struct FbFormat
{
    uint bytesPerPixel;
    uint redShift, redMask;
    uint greenShift, greenMask;
    uint blueShift, blueMask;

    uint rgb(uint r, uint g, uint b)
    {
        return 0;
    }
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
        pixels = kernelPhysicalToVirtual!ubyte(mbData.common.framebuffer_addr);
        if (mbData.common.framebuffer_type != MULTIBOOT_FRAMEBUFFER_TYPE_RGB)
        {
            debugPort.writeStringLn("Unsupported framebuffer format");
            while (1)
            {
                asm nothrow @nogc
                {
                    cli;
                    hlt;
                }
            }
        }
        format.bytesPerPixel = mbData.common.framebuffer_bpp / 8;
        format.redMask = mbData.framebuffer_red_mask_size;

        debugPort.writeStringLn("Initialising framebuffer:");
        debugPort.writeString("BPP:");
        debugPort.writeULong(format.bytesPerPixel);
        debugPort.writeString("\nRM:");
        debugPort.writeULong(format.redMask);
    }
}
