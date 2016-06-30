module hxi.memory.paging;

import hxi.memory.allocators;
import hxi.linker;
import barec;

enum MapMode : ulong
{
	present = 0x1,
	readWrite = 0x2,
	user = 0x4,
	largeSize = 0x8,
	noExecute = 0x10,
	//
	none = 0x0,
	kernelPage = present + readWrite,
	userPage = present + readWrite + user
}

ulong virtualToPhysical(T)(T* ptr) nothrow @nogc
{
	ulong addr = cast(ulong)(ptr);
	addr = addr & 0x7FFF_FFFF_FFFF;
	return addr;
}

T* physicalToVirtual(T)(ulong addr) nothrow @nogc
{
	return cast(T*)(LinkerScript.kernelVMA() + addr);
}

struct PagePML4
{
	ulong data = 0;
nothrow:
@nogc:
	// dfmt off
	mixin(Bitfield!(data,
		"present", 1,
		"readWrite", 1,
		"user", 1,
		"writeThrough", 1,
		"cacheDisabled", 1,
		"accessed", 1,
		"mbz", 3,
		"available", 3,
		"raddress", 40,
		"available2", 11,
		"nx", 1));
	// dfmt on

	void address(ulong ptr)
	{
		raddress = ptr >> 12;
	}

	ulong address()
	{
		return raddress << 12;
	}
}

struct PagePML3
{
	ulong data = 0;
nothrow:
@nogc:
	// dfmt off
	mixin(Bitfield!(data,
		"present", 1,
		"readWrite", 1,
		"user", 1,
		"writeThrough", 1,
		"cacheDisabled", 1,
		"accessed", 1,
		"mbz", 3,
		"available", 3,
		"raddress", 40,
		"available2", 11,
		"nx", 1));
	// dfmt on

	void address(ulong ptr)
	{
		raddress = ptr >> 12;
	}

	ulong address()
	{
		return raddress << 12;
	}
}

struct PagePML2
{
	ulong data = 0;
nothrow:
@nogc:
	// dfmt off
	mixin(Bitfield!(data,
		"present", 1,
		"readWrite", 1,
		"user", 1,
		"writeThrough", 1,
		"cacheDisabled", 1,
		"accessed", 1,
		"dirty", 1,
		"pageSize", 1,
		"global", 1,
		"available", 3,
		"raddress", 40,
		"available2", 11,
		"nx", 1));
	// dfmt on

	void address(ulong ptr)
	{
		raddress = ptr >> 12;
	}

	ulong address()
	{
		return raddress << 12;
	}
}

struct PagePML1
{
	ulong data = 0;
nothrow:
@nogc:
	// dfmt off
	mixin(Bitfield!(data,
		"present", 1,
		"readWrite", 1,
		"user", 1,
		"writeThrough", 1,
		"cacheDisabled", 1,
		"accessed", 1,
		"dirty", 1,
		"pat", 1,
		"global", 1,
		"available", 3,
		"raddress", 40,
		"available2", 11,
		"nx", 1));
	// dfmt on

	void address(ulong ptr)
	{
		raddress = ptr >> 12;
	}

	ulong address()
	{
		return raddress << 12;
	}

	void mapMode(MapMode mm)
	{
		present = ((mm & MapMode.present) > 0) ? 1 : 0;
		readWrite = ((mm & MapMode.readWrite) > 0) ? 1 : 0;
		user = ((mm & MapMode.user) > 0) ? 1 : 0;
		nx = ((mm & MapMode.noExecute) > 0) ? 1 : 0;
	}
}

enum pageLvl4Shift = 39;
enum pageLvl3Shift = 30;
enum pageLvl2Shift = 21;
enum pageLvl1Shift = 12;
enum pageLvlMask = 0x1FF;
private enum ulong upperHalfMask = 0xFFFFL << 48;
enum ulong pageRecursiveIdx = 510;
enum pageLvl4Addr = cast(PagePML4*)(
		upperHalfMask | (pageRecursiveIdx << pageLvl4Shift) | (pageRecursiveIdx << pageLvl3Shift) | (
		pageRecursiveIdx << pageLvl2Shift) | (pageRecursiveIdx << pageLvl1Shift));
enum pageLvl3Addr = cast(PagePML3*)(
		upperHalfMask | (pageRecursiveIdx << pageLvl4Shift) | (pageRecursiveIdx << pageLvl3Shift) | (
		pageRecursiveIdx << pageLvl2Shift));
enum pageLvl2Addr = cast(PagePML2*)(
		upperHalfMask | (pageRecursiveIdx << pageLvl4Shift) | (pageRecursiveIdx << pageLvl3Shift));
enum pageLvl1Addr = cast(PagePML1*)(upperHalfMask | (pageRecursiveIdx << pageLvl4Shift));

private PagePML4* tempP4() nothrow @nogc
{
	return cast(PagePML4*)(LinkerScript.kernelEnd2M());
}

private PagePML3* tempP3() nothrow @nogc
{
	return cast(PagePML3*)(LinkerScript.kernelEnd2M()) + 512;
}

private PagePML2* tempP2() nothrow @nogc
{
	return cast(PagePML2*)(LinkerScript.kernelEnd2M()) + 1024;
}

private PagePML1* tempP1() nothrow @nogc
{
	return cast(PagePML1*)(LinkerScript.kernelEnd2M()) + 1536;
}

/// An inactive page table
struct PageTable
{
	/// Physical pointer to root
	ulong root;
	@disable this(this);
nothrow:
@nogc:
	/// Setup the page table - set the recursive index and temporary access pages
	private void initialize()
	{
		mapAddressPages(0);
		tempP4()[pageRecursiveIdx].data = 0x3 + root;
		mapAddress(tempP1(), MapMode.kernelPage, false);
		mapAddress(tempP2(), MapMode.kernelPage, false);
		mapAddress(tempP3(), MapMode.kernelPage, false);
		mapAddress(tempP4(), MapMode.kernelPage, false);
	}

	/// Make pages for virtual address addr accessible.
	private void mapAddressPages(ulong addr)
	{
		PageIndices pind;
		Paging.splitAddress(addr, pind);
		PagePML1* tpage;
		// map P4 array
		tpage = ActivePageTable.getPageForAddress!1(tempP4());
		tpage.present = 1;
		tpage.address = root;
		Paging.flushTLB(tempP4());
		// map P3 array
		PagePML4* e4 = &tempP4()[pind.level4];
		if (!e4.present)
		{
			e4.data = 0x7;
			e4.address = PhysicalPageAllocator.mapPage();
		}
		tpage = ActivePageTable.getPageForAddress!1(tempP3());
		tpage.present = 1;
		tpage.address = e4.address;
		Paging.flushTLB(tempP3());
		// map P2 array
		PagePML3* e3 = &tempP3()[pind.level3];
		if (!e3.present)
		{
			e3.data = 0x7;
			e3.address = PhysicalPageAllocator.mapPage();
		}
		tpage = ActivePageTable.getPageForAddress!1(tempP3());
		tpage.present = 1;
		tpage.address = e3.address;
		Paging.flushTLB(tempP2());
		// map P1 array
		PagePML2* e2 = &tempP2()[pind.level2];
		if (!e2.present)
		{
			e2.data = 0x7;
			e2.address = PhysicalPageAllocator.mapPage();
		}
		tpage = ActivePageTable.getPageForAddress!1(tempP2());
		tpage.present = 1;
		tpage.address = e2.address;
		Paging.flushTLB(tempP1());
	}

	void mapAddress(void* vptr, MapMode mm = MapMode.kernelPage, bool allocateMemory = true)
	{
		ulong addr = cast(ulong) vptr;
		mapAddressPages(addr);
		PagePML1* p1 = &tempP1()[(addr >> pageLvl1Shift) & pageLvlMask];
		if (allocateMemory)
		{
			p1.present = 1;
			p1.address = PhysicalPageAllocator.mapPage();
		}
		else
		{
			p1.present = 0;
			p1.address = 0;
		}
		p1.mapMode = mm;
	}
}

/// Contains access methods for the current page table, through recursively mapped 510th page
struct ActivePageTable
{
	@disable this();
	@disable this(this);
static:
nothrow:
@nogc:
	/// level must be 1,2,3 or 4
	auto getPageForAddress(uint level = 1)(void* ptr)
	{
		ulong addr = cast(ulong) ptr;
		static if (level == 4)
		{
			return &pageLvl4Addr[addr >> pageLvl4Shift];
		}
		else static if (level == 3)
		{
			return &pageLvl3Addr[addr >> pageLvl3Shift];
		}
		else static if (level == 2)
		{
			return &pageLvl2Addr[addr >> pageLvl2Shift];
		}
		else static if (level == 1)
		{
			return &pageLvl1Addr[addr >> pageLvl1Shift];
		}
		else
		{
			static assert(0, "Wrong page level, should be 1,2,3 or 4");
		}
	}

	void mapAddress(void* vptr, MapMode mm = MapMode.kernelPage, bool allocateMemory = true)
	{
		ulong addr = cast(ulong) vptr;
		PagePML4* p4 = getPageForAddress!4(vptr);
		if (!p4.present)
		{
			p4.data = 0x7;
			p4.address = PhysicalPageAllocator.mapPage();
		}
		PagePML3* p3 = getPageForAddress!3(vptr);
		if (!p3.present)
		{
			p3.data = 0x7;
			p3.address = PhysicalPageAllocator.mapPage();
		}
		PagePML2* p2 = getPageForAddress!2(vptr);
		if (!p2.present)
		{
			p2.data = 0x7;
			p2.address = PhysicalPageAllocator.mapPage();
		}
		PagePML1* p1 = getPageForAddress!1(vptr);
		if (allocateMemory)
		{
			p1.present = 1;
			p1.address = PhysicalPageAllocator.mapPage();
		}
		else
		{
			p1.present = 0;
			p1.address = 0;
		}
		p1.mapMode = mm;
	}
}

struct PageIndices
{
	ushort level4;
	ushort level3;
	ushort level2;
	ushort level1;
}

struct Paging
{
	@disable this();
	@disable this(this);
static:
nothrow:
@nogc:
	void initialize()
	{
		ActivePageTable.mapAddress(tempP1(), MapMode.kernelPage, false);
		ActivePageTable.mapAddress(tempP2(), MapMode.kernelPage, false);
		ActivePageTable.mapAddress(tempP3(), MapMode.kernelPage, false);
		ActivePageTable.mapAddress(tempP4(), MapMode.kernelPage, false);
		PageTable ptNew = PageTable(PhysicalPageAllocator.mapPage());
		ptNew.initialize();
	}

	void splitAddress(void* vaddr, out PageIndices ind)
	{
		ulong addr = cast(ulong) vaddr;
		ind.level4 = (addr >> pageLvl4Shift) & pageLvlMask;
		ind.level3 = (addr >> pageLvl3Shift) & pageLvlMask;
		ind.level2 = (addr >> pageLvl2Shift) & pageLvlMask;
		ind.level1 = (addr >> pageLvl1Shift) & pageLvlMask;
	}

	void splitAddress(ulong vaddr, out PageIndices ind)
	{
		ind.level4 = (vaddr >> pageLvl4Shift) & pageLvlMask;
		ind.level3 = (vaddr >> pageLvl3Shift) & pageLvlMask;
		ind.level2 = (vaddr >> pageLvl2Shift) & pageLvlMask;
		ind.level1 = (vaddr >> pageLvl1Shift) & pageLvlMask;
	}

	void flushTLB(ulong addr)
	{
		asm nothrow @nogc
		{
			mov RAX, addr;
			invlpg [RAX];
		}
	}

	void flushTLB(void* addr)
	{
		asm nothrow @nogc
		{
			mov RAX, addr;
			invlpg [RAX];
		}
	}
}