module hxi.kmain;

import hxi.multiboot;
import hxi.linker;
import hxi.memory.allocators;
import hxi.memory.paging;

extern (C) void kmain(long magic, void* bdata) nothrow @nogc
{
	PhysicalPageAllocator.setRangeType(0, 1024 * 1024, PhysicalPageAllocator.MapStatus.SystemRO);
	PhysicalPageAllocator.setRangeType(
		kernelVirtualToPhysical(LinkerScript.textStart()),
		kernelVirtualToPhysical(LinkerScript.kernelEnd()),
		PhysicalPageAllocator.MapStatus.KernelCode);
	ubyte* fb;
	ulong fblen, fbptr;
	void* mbit = bdata; // multiboot iterator
	/*while (1)
	{
		multiboot_tag* rtag = cast(multiboot_tag*) mbit;
		if (rtag.type == MULTIBOOT_TAG_TYPE_END)
		{
			break;
		}
		switch (rtag.type)
		{
		case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
			multiboot_tag_framebuffer* tag = cast(multiboot_tag_framebuffer*) mbit;
			fb = cast(ubyte*) tag.common.framebuffer_addr;
			fblen = tag.common.framebuffer_pitch * tag.common.framebuffer_height * tag.common.framebuffer_bpp / 8;
			fbptr = cast(ulong) fb;
			PhysicalPageAllocator.setRangeType(fbptr, fbptr + fblen,
				PhysicalPageAllocator.MapStatus.SystemRW);
			break;
		case MULTIBOOT_TAG_TYPE_MMAP:
			break;
		default:
			break;
		}
		mbit += rtag.size;
	}*/
	Paging.initialize();
	// Identity map framebuffer
	/*foreach (void* page; byCoveredPages(fbptr, fbptr + fblen))
	{
		ActivePageTable.mapAddress(page, MapMode.userPage, false, cast(ulong) page);
	}
	// Put some white pixels
	for (int i = 0; i < 1024*300; i++)
	{
		fb[i] = 0xFF;
	}*/
	while (1)
	{
		asm nothrow @nogc
		{
			cli;
			hlt;
		}
	}
}
