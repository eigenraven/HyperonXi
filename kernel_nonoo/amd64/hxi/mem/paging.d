module hxi.mem.paging;

import kstdlib;
import asmutils;
import hxi.mem.memory;
import hxi.mem.physical_allocator;

nothrow:
@nogc:

enum PageFlags : uint
{
	Present = 0x1,
	ReadWrite = 0x2,
	User = 0x4,
	LargeSize = 0x8,
	NoExecute = 0x10,
	NoCache = 0x20,
	WriteThroughCache = 0x40,
	//
	None = 0x0,
	KernelRO = Present | NoExecute,
	KernelRW = Present | ReadWrite | NoExecute,
	KernelX = Present,
	UserRO = Present | User | NoExecute,
	UserRW = Present | User | ReadWrite | NoExecute,
	UserX = Present | User,
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

	void address(PhysicalAddress ptr)
	{
		raddress = cast(ulong)(ptr >> 12);
	}

	PhysicalAddress address()
	{
		return cast(PhysicalAddress)(raddress << 12);
	}

	void flags(PageFlags mm)
	{
		present = ((mm & PageFlags.Present) > 0) ? 1 : 0;
		readWrite = ((mm & PageFlags.ReadWrite) > 0) ? 1 : 0;
		user = ((mm & PageFlags.User) > 0) ? 1 : 0;
		if (nxBitAvailable)
			nx = ((mm & PageFlags.NoExecute) > 0) ? 1 : 0;
		writeThrough = ((mm & PageFlags.WriteThroughCache) > 0) ? 1 : 0;
		cacheDisabled = ((mm & PageFlags.NoCache) > 0) ? 1 : 0;
	}

	PagePML3[] subpages()
	{
		return physicalSpaceToPhmap!PagePML3(address)[0 .. 512];
	}

	bool elevateFlags(PageFlags childFlags)
	{
		bool changed = false;
		if (childFlags & PageFlags.ReadWrite && !readWrite)
		{
			readWrite = true;
			changed = true;
		}
		if (childFlags & PageFlags.User && !user)
		{
			user = true;
			changed = true;
		}
		return changed;
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
		"dirty", 1,
		"pageSize", 1,
		"global", 1,
		"available", 3,
		"raddress", 40,
		"available2", 11,
		"nx", 1));
	// dfmt on

	void address(PhysicalAddress ptr)
	{
		raddress = cast(ulong)(ptr >> 12);
	}

	PhysicalAddress address()
	{
		return cast(PhysicalAddress)(raddress << 12);
	}

	void flags(PageFlags mm)
	{
		present = ((mm & PageFlags.Present) > 0) ? 1 : 0;
		readWrite = ((mm & PageFlags.ReadWrite) > 0) ? 1 : 0;
		user = ((mm & PageFlags.User) > 0) ? 1 : 0;
		if (nxBitAvailable)
			nx = ((mm & PageFlags.NoExecute) > 0) ? 1 : 0;
		writeThrough = ((mm & PageFlags.WriteThroughCache) > 0) ? 1 : 0;
		cacheDisabled = ((mm & PageFlags.NoCache) > 0) ? 1 : 0;
		pageSize = ((mm & PageFlags.LargeSize) > 0) ? 1 : 0;
	}

	bool elevateFlags(PageFlags childFlags)
	{
		bool changed = false;
		if (childFlags & PageFlags.ReadWrite && !readWrite)
		{
			readWrite = true;
			changed = true;
		}
		if (childFlags & PageFlags.User && !user)
		{
			user = true;
			changed = true;
		}
		return changed;
	}

	PagePML2[] subpages()
	{
		if (pageSize == 1)
			return null;
		return physicalSpaceToPhmap!PagePML2(address)[0 .. 512];
	}

	ubyte[] dataStored()
	{
		if (present == 0 || pageSize == 0)
			return null;
		return physicalSpaceToPhmap!ubyte(address)[0 .. 1.GB];
	}

	ulong[] longDataStored()
	{
		if (present == 0 || pageSize == 0)
			return null;
		return physicalSpaceToPhmap!ulong(address)[0 .. 1.GB / ulong.sizeof];
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

	void address(PhysicalAddress ptr)
	{
		raddress = cast(ulong)(ptr >> 12);
	}

	PhysicalAddress address()
	{
		return cast(PhysicalAddress)(raddress << 12);
	}

	void flags(PageFlags mm)
	{
		present = ((mm & PageFlags.Present) > 0) ? 1 : 0;
		readWrite = ((mm & PageFlags.ReadWrite) > 0) ? 1 : 0;
		user = ((mm & PageFlags.User) > 0) ? 1 : 0;
		if (nxBitAvailable)
			nx = ((mm & PageFlags.NoExecute) > 0) ? 1 : 0;
		writeThrough = ((mm & PageFlags.WriteThroughCache) > 0) ? 1 : 0;
		cacheDisabled = ((mm & PageFlags.NoCache) > 0) ? 1 : 0;
		pageSize = ((mm & PageFlags.LargeSize) > 0) ? 1 : 0;
	}

	bool elevateFlags(PageFlags childFlags)
	{
		bool changed = false;
		if (childFlags & PageFlags.ReadWrite && !readWrite)
		{
			readWrite = true;
			changed = true;
		}
		if (childFlags & PageFlags.User && !user)
		{
			user = true;
			changed = true;
		}
		return changed;
	}

	PagePML1[] subpages()
	{
		if (pageSize == 1)
			return null;
		return physicalSpaceToPhmap!PagePML1(address)[0 .. 512];
	}

	ubyte[] dataStored()
	{
		if (present == 0 || pageSize == 0)
			return null;
		return physicalSpaceToPhmap!ubyte(address)[0 .. 2.MB];
	}

	ulong[] longDataStored()
	{
		if (present == 0 || pageSize == 0)
			return null;
		return physicalSpaceToPhmap!ulong(address)[0 .. 2.MB / ulong.sizeof];
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

	void address(PhysicalAddress ptr)
	{
		raddress = cast(ulong)(ptr >> 12);
	}

	PhysicalAddress address()
	{
		return cast(PhysicalAddress)(raddress << 12);
	}

	void flags(PageFlags mm)
	{
		present = ((mm & PageFlags.Present) > 0) ? 1 : 0;
		readWrite = ((mm & PageFlags.ReadWrite) > 0) ? 1 : 0;
		user = ((mm & PageFlags.User) > 0) ? 1 : 0;
		if (nxBitAvailable)
			nx = ((mm & PageFlags.NoExecute) > 0) ? 1 : 0;
		writeThrough = ((mm & PageFlags.WriteThroughCache) > 0) ? 1 : 0;
		cacheDisabled = ((mm & PageFlags.NoCache) > 0) ? 1 : 0;
	}

	bool elevateFlags(PageFlags childFlags)
	{
		bool changed = false;
		if (childFlags & PageFlags.ReadWrite && !readWrite)
		{
			readWrite = true;
			changed = true;
		}
		if (childFlags & PageFlags.User && !user)
		{
			user = true;
			changed = true;
		}
		return changed;
	}

	ubyte[] dataStored()
	{
		if (present == 0)
			return null;
		return physicalSpaceToPhmap!ubyte(address)[0 .. PAGE_GRANULARITY];
	}

	ulong[] longDataStored()
	{
		if (present == 0)
			return null;
		return physicalSpaceToPhmap!ulong(address)[0 .. PAGE_GRANULARITY / ulong.sizeof];
	}
}

private enum pageLvl4Shift = 39;
private enum pageLvl3Shift = 30;
private enum pageLvl2Shift = 21;
private enum pageLvl1Shift = 12;
private enum pageLvlMask = 0x1FF;
private enum ulong upperHalfMask = 0xFFFFL << 48;
private enum ulong pageRecursiveIdx = 510;

enum PageSize : ulong
{
	Size4k = 4.KB,
	Size2M = 2.MB,
	Size1G = 1.GB,

	Smallest = Size4k
}

private struct PageIndices
{
	ushort level4;
	ushort level3;
	ushort level2;
	ushort level1;
}

private PageIndices splitAddress(void* vaddr)
{
	PageIndices ind;
	ulong addr = cast(ulong) vaddr;
	ind.level4 = (addr >> pageLvl4Shift) & pageLvlMask;
	ind.level3 = (addr >> pageLvl3Shift) & pageLvlMask;
	ind.level2 = (addr >> pageLvl2Shift) & pageLvlMask;
	ind.level1 = (addr >> pageLvl1Shift) & pageLvlMask;
	return ind;
}

private PageIndices splitAddress(ulong vaddr)
{
	PageIndices ind;
	ind.level4 = (vaddr >> pageLvl4Shift) & pageLvlMask;
	ind.level3 = (vaddr >> pageLvl3Shift) & pageLvlMask;
	ind.level2 = (vaddr >> pageLvl2Shift) & pageLvlMask;
	ind.level1 = (vaddr >> pageLvl1Shift) & pageLvlMask;
	return ind;
}

struct PageTable
{
	/// Physical address of the root table.
	PhysicalAddress root;
	@disable this(this);

nothrow:
@nogc:

	static PageTable createBlank()
	{
		PageTable pt;
		pt.root = allocateZeroedPhysicalPage();
		return pt;
	}

	static PageTable current()
	{
		ulong addr = getCR3();
		return PageTable(PhysicalAddress(addr));
	}

	PagePML4[] entries()
	{
		return physicalSpaceToPhmap!PagePML4(root)[0 .. 512];
	}

	/// Returns number of successfully allocated pages
	uint updateEntryRange(PageSize targetSize, PageFlags targetFlags,
			void* startAddr, void* endAddr, PhysicalAddress startMapping = pnull)
	{
		uint success = 0;
		for (void* addr = startAddr; addr < endAddr; addr += cast(ulong) targetSize)
		{
			if (updateEntry(targetSize, targetFlags, addr, startMapping) == false)
				return success;
			success++;
			if (startMapping != pnull)
			{
				startMapping += cast(ulong) targetSize;
			}
		}
		return success;
	}

	bool updateEntry(PageSize targetSize, PageFlags targetFlags, void* vaddr,
			PhysicalAddress newMapping = pnull)
	{
		scope (exit)
			flushTLB(vaddr);

		PageIndices inds = splitAddress(vaddr);
		PagePML4* p4entry = &entries()[inds.level4];
		targetFlags &= ~(PageFlags.LargeSize);
		if (!p4entry.present)
		{
			if (!(targetFlags & PageFlags.Present))
				return true;
			p4entry.address = allocateZeroedPhysicalPage();
			p4entry.flags = targetFlags;
		}
		p4entry.elevateFlags(targetFlags);
		//
		int output = -1;
		void updatePageEntry(EType, PageSize sz)(EType* entry, ref int outp) nothrow @nogc
		{
			if (targetSize > sz)
				return;
			if (!entry.present)
			{
				if ((targetFlags & PageFlags.Present) == 0) // not present and not wanted => OK
				{
					outp = 1;
					return;
				}
				// not present and wanted
				if (targetSize == sz) // if target size => create&fill in data
				{
					entry.flags = targetFlags | PageFlags.LargeSize;
					entry.address = (newMapping == pnull) ? allocateZeroedPhysicalPage()
						: newMapping;
					outp = 1;
					return;
				}
				else // not present intermediate page => allocate
				{
					entry.flags = targetFlags;
					entry.address = allocateZeroedPhysicalPage();
					return;
				}
			}
			else // already present
			{
				if (targetSize == sz) // and is the final page
				{
					if ((targetFlags & PageFlags.Present) == 0) // but not wanted
					{
						entry.address = PhysicalAddress(0);
						entry.flags = PageFlags.None;
						outp = 1;
						return;
					}
					else // and wanted => update flags & mapping
					{
						entry.flags = targetFlags;
						if (newMapping != pnull)
						{
							entry.address = newMapping;
						}
						outp = 1;
						return;
					}
				}
				else // but is intermediate => elevate flags
				{
					entry.elevateFlags(targetFlags);
					return;
				}
			}
		}

		//
		PagePML3* p3entry = &p4entry.subpages()[inds.level3];
		updatePageEntry!(PagePML3, PageSize.Size1G)(p3entry, output);
		if (output > -1)
			return cast(bool) output;
		PagePML2* p2entry = &p3entry.subpages()[inds.level2];
		updatePageEntry!(PagePML2, PageSize.Size2M)(p2entry, output);
		if (output > -1)
			return cast(bool) output;
		PagePML1* p1entry = &p2entry.subpages()[inds.level1];
		updatePageEntry!(PagePML1, PageSize.Size4k)(p1entry, output);
		if (output > -1)
			return cast(bool) output;
		return false;
	}
}

private __gshared PageSize maxPageSize_;
private __gshared bool nxBitAvailable_;

PageSize maxPageSize() nothrow @nogc @trusted
{
	return maxPageSize_;
}

bool nxBitAvailable() nothrow @nogc @trusted
{
	return nxBitAvailable_;
}

///
void setupPaging()
{
	import hxi.log : logf, LogLevel;
	{
		maxPageSize_ = PageSize.Size4k;
		import cpuid.x86_any : _cpuid, CpuInfo;

		CpuInfo infoPG = _cpuid(0x80000001);
		bool s2m = (infoPG.d & (1 << 3)) > 0;
		nxBitAvailable_ = (infoPG.d & (1 << 20)) > 0;
		if (nxBitAvailable_)
			logf(LogLevel.Trace, "NX bit available");
		else
			logf(LogLevel.Trace, "NX bit unavailable");
		if (s2m)
		{
			maxPageSize_ = PageSize.Size2M;
			bool s1g = (infoPG.d & (1 << 26)) > 0;
			if (s1g)
				maxPageSize_ = PageSize.Size1G;
		}
		logf(LogLevel.Trace, "Max supported page size: %b", cast(ulong) maxPageSize_);
	}
	PageTable fresh = PageTable.createBlank();
	// Map lower 2 MB
	fresh.updateEntry(PageSize.Size4k, PageFlags.KernelRW, null, PhysicalAddress(0));
	// Map the GDT
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRO, LinkerScript.multibootStart,
			LinkerScript.multibootEnd, kernelLocalSpaceToPhysical(LinkerScript.multibootStart));
	// Map kernel sections
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelX, LinkerScript.textStart,
			LinkerScript.textEnd, kernelLocalSpaceToPhysical(LinkerScript.textStart));
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRW, LinkerScript.dataStart,
			LinkerScript.dataEnd, kernelLocalSpaceToPhysical(LinkerScript.dataStart));
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRO, LinkerScript.rodataStart,
			LinkerScript.rodataEnd, kernelLocalSpaceToPhysical(LinkerScript.rodataStart));
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRW, LinkerScript.bssStart,
			LinkerScript.bssEnd, kernelLocalSpaceToPhysical(LinkerScript.bssStart));
	fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRO, LinkerScript.ehframeStart,
			LinkerScript.ehframeEnd, kernelLocalSpaceToPhysical(LinkerScript.ehframeStart));
	// Map physical memory using memory map
	for (MemoryMapEntry* entry = memoryMapHead; entry !is null; entry = entry.next)
	{
		void* begin = physicalSpaceToPhmap(entry.start);
		void* end = physicalSpaceToPhmap(PhysicalAddress(entry.start + entry.length));
		fresh.updateEntryRange(PageSize.Size4k, PageFlags.KernelRW, begin, end, entry.start);
	}
	// Update CR3 with the new page table
	setCR3(cast(ulong) fresh.root);
}
