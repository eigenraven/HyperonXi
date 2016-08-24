module hxi.kmain;

import hxi.multiboot;
import hxi.linker;
import hxi.drivers.serial;
import hxi.memory.allocators;
import hxi.memory.paging;
import hxi.fbcon.framebuffer;

extern (C) void kmain(long magic, void* bdata) nothrow @nogc
{
    debugPort.port = 0x3f8;
    debugPort.initialize();
    debugPort.writeStringLn("Kernel main executing");
    debugPort.writeStringLn("Multiboot data: ");
    debugPort.writeULong(magic);
    debugPort.writeByte(' ');
    debugPort.writeULong(cast(ulong) bdata);
    debugPort.writeByte('\n');
    PhysicalPageAllocator.mmapLow[] = PhysicalPageAllocator.MapStatus.Free;
    PhysicalPageAllocator.setRangeType(0, 1024 * 1024, PhysicalPageAllocator.MapStatus.SystemRO);
    PhysicalPageAllocator.setRangeType(kernelVirtualToPhysical(LinkerScript.textStart()),
            kernelVirtualToPhysical(LinkerScript.kernelEnd()),
            PhysicalPageAllocator.MapStatus.KernelCode);
    ubyte* fb;
    ulong fblen, fbptr;
    int mb_totalsize = *(cast(int*)(bdata));
    void* mbit = bdata + 8; // multiboot iterator
    Framebuffer mainFb = void;
    multiboot_tag_framebuffer* fbTag;
    while (mbit < (bdata + mb_totalsize))
    {
        multiboot_tag* rtag = cast(multiboot_tag*) mbit;
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
            multiboot_tag_framebuffer* tag = cast(multiboot_tag_framebuffer*) mbit;
            fb = cast(ubyte*) tag.common.framebuffer_addr;
            fbTag = kernelPhysicalToVirtual!(multiboot_tag_framebuffer)(cast(ulong) tag);
            fblen = tag.common.framebuffer_pitch
                * tag.common.framebuffer_height * tag.common.framebuffer_bpp / 8;
            fbptr = cast(ulong) fb;
            PhysicalPageAllocator.setRangeType(fbptr, fbptr + fblen,
                    PhysicalPageAllocator.MapStatus.SystemRW);
            break;
        case MULTIBOOT_TAG_TYPE_MMAP:
            break;
        default:
            break;
        }
        mbit += (rtag.size + 7) & (~7UL);
    }
    Paging.initialize();
    // Identity map framebuffer
    foreach (void* page; byCoveredPages(bdata + 8, bdata + mb_totalsize))
    {
        ActivePageTable.mapAddress(kernelPhysicalToVirtual!(void)(cast(ulong) page),
                MapMode.kernelPage, false, cast(ulong) page);
    }
    foreach (void* page; byCoveredPages(fbptr, fbptr + fblen))
    {
        ActivePageTable.mapAddress(page, MapMode.userPage, false, cast(ulong) page);
    }
	mainFb = Framebuffer(fbTag);
    // Put some white pixels
    for (int i = 0; i < 1024 * 300; i++)
    {
        fb[i] = (i & 0xFF);
    }
    while (1)
    {
        asm nothrow @nogc
        {
            cli;
            hlt;
        }
    }
}
