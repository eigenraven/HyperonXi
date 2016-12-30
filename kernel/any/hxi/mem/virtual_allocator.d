module hxi.mem.virtual_allocator;

import kstdlib;
import hxi.mem.memory;
public import hxi.mem.paging : PageFlags;
import hxi.mem.paging;
import hxi.mem.physical_allocator;

nothrow:
@nogc:

struct VirtualMemoryAllocator(ulong minAddr, ulong maxAddr)
{
static:
nothrow:
@nogc:
	__gshared ulong lastFreeAddr;

	void setup()
	{
		lastFreeAddr = minAddr;
	}

	void* allocatePages(uint amount = 1, PageFlags flags = PageFlags.KernelRW)
	{
		ulong addr0 = lastFreeAddr;
		ulong addr1 = addr0 + amount * PAGE_GRANULARITY;
		if (addr1 >= maxAddr)
			return null;
		lastFreeAddr = addr1;
		PageTable ct = PageTable.current;
		ct.updateEntryRange(PageSize.Smallest, flags, cast(void*) addr0, cast(void*) addr1);
		return cast(void*) addr0;
	}

	void freePages(void* first, uint amount)
	{
		//
	}
}

alias KernelVirtualMemoryAllocator = VirtualMemoryAllocator!(
		cast(ulong) VIRTUAL_MAPPABLE_KSTART, cast(ulong) VIRTUAL_MAPPABLE_KEND);
alias UserVirtualMemoryAllocator = VirtualMemoryAllocator!(
		cast(ulong) VIRTUAL_MAPPABLE_USTART, cast(ulong) VIRTUAL_MAPPABLE_UEND);

void setupVirtualAllocator()
{
	KernelVirtualMemoryAllocator.setup();
	UserVirtualMemoryAllocator.setup();
}
