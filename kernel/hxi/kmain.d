module hxi.kmain;

import barec;
import hxi.multiboot;
import hxi.linker;
import hxi.drivers.serial;
import hxi.memory.allocators;
import hxi.memory.paging;
import hxi.fbcon.framebuffer;
import hxi.fbcon.textbuffer;
import hxi.archinit;
import hxi.output;

extern (C) void kmain(long magic, void* bdata) nothrow @nogc
{
    bdata = kernelPhysicalToVirtual!void(cast(ulong) bdata);
    int bdataLen = *cast(int*) bdata;
    setLoggingOutputFramebuffer(null);
    debugPort.port = 0x3f8;
    debugPort.initialize();
    debugPort.writeStringLn("Kernel main executing");
    debugPort.writeStringLn("Multiboot data: ");
    debugPort.writeULong(magic);
    debugPort.writeByte(' ');
    debugPort.writeULong(cast(ulong) bdata);
    debugPort.writeByte('\n');
    hxiArchInitZero(bdata);
    PhysicalPageAllocator.mmapLow[] = PhysicalPageAllocator.MapStatus.Free;
    PhysicalPageAllocator.setRangeType(0, 1024 * 1024, PhysicalPageAllocator.MapStatus.SystemRO);
    PhysicalPageAllocator.setRangeType(kernelVirtualToPhysical(LinkerScript.textStart()),
            kernelVirtualToPhysical(LinkerScript.kernelEnd()),
            PhysicalPageAllocator.MapStatus.KernelCode);
    ubyte* fb;
    ulong fblen, fbptr;
    Framebuffer mainFb = void;
    multiboot_tag_framebuffer fbTag;
    foreach (rtag; iterateTags(bdata))
    {
        debugPort.writeString("MB tag:");
        debugPort.writeULong(rtag.type);
        debugPort.writeByte('\n');
        if (rtag.size == 0)
        {
            break;
        }
        if (rtag.type == MULTIBOOT_TAG_TYPE_END)
        {
            break;
        }
        switch (rtag.type)
        {
        case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
            multiboot_tag_framebuffer* tag = cast(multiboot_tag_framebuffer*) rtag;
            fb = cast(ubyte*) tag.common.framebuffer_addr;
            fbTag = *tag;
            fblen = tag.common.framebuffer_pitch
                * tag.common.framebuffer_height * tag.common.framebuffer_bpp / 8;
            fbptr = cast(ulong) fb;
            debugPort.writeString("FBType: ");
            debugPort.writeULong(tag.common.framebuffer_type);
            debugPort.writeByte('\n');
            PhysicalPageAllocator.setRangeType(fbptr, fbptr + fblen,
                    PhysicalPageAllocator.MapStatus.SystemRW);
            break;
        case MULTIBOOT_TAG_TYPE_MMAP:
            break;
        default:
            break;
        }
    }
    Paging.initialize();
    // Identity map framebuffer
    foreach (void* page; byCoveredPages(bdata, bdata + bdataLen))
    {
        ActivePageTable.mapAddress(kernelPhysicalToVirtual!(void)(cast(ulong) page),
                MapMode.kernelPage, false, cast(ulong) page);
    }
    log(LogLevel.Info, IntToWStr!(__LINE__, 10)); //T:R
    foreach (void* page; byCoveredPages(fbptr, fbptr + fblen))
    {
        ActivePageTable.mapAddress(page, MapMode.userPage, false, cast(ulong) page);
    }
    // clear fb
    mainFb = Framebuffer(&fbTag);
    TextFramebuffer txtfb;
    txtfb.initialize(&mainFb);
    txtfb.redraw();
    txtfb.printStringAttr("Hyperon Xi ", cast(ushort) 0xFFEE);
    txtfb.printStringAttr("booting...\n");
    txtfb.printStringAttr("Snowmen invasion! \u2603\u2603\u2603\n"w, colorChar(0x8888FF));
    setLoggingOutputFramebuffer(&txtfb);

    log(LogLevel.Trace, "Begin hxiArchInit");
    hxiArchInit(bdata);
    log(LogLevel.Trace, "Finished hxiArchInit");

    log(LogLevel.Trace, "Testing 0x80");
    asm nothrow @nogc
    {
        mov R8, 0;
        mov RAX, 7;
        idiv R8;
    }
    log(LogLevel.Trace, "Tested 0x80");

    while (1)
    {
        asm nothrow @nogc
        {
            cli;
            hlt;
        }
    }
}
