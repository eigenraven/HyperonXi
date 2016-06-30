module hxi.memory.allocators;

import barec;

struct PhysicalPageAllocator
{
	enum MapStatus : ubyte
	{
		Free = 0,
		Allocated = 1,
		KernelCode = 2,
		SystemRO = 3,
		SystemRW = 4,
		SystemWO = 5,
		OutOfBounds = 0xFF
	}

nothrow:
@nogc:
static:
	/// Memory map for the first gigabyte of physical memory
	align(4096) __gshared ubyte[262_144] mmapLow;

	MapStatus getStatus(ulong address)
	{
		address /= 4096;
		if (address >= mmapLow.length)
			return MapStatus.OutOfBounds;
		return cast(MapStatus)(mmapLow.ptr[address]);
	}

	void setRangeType(ulong start, ulong end, MapStatus status)
	{
		start &= ~4095;
		if ((end & 4095) > 0)
		{
			end = 4096 + (end & (~4095));
		}
		start >>= 12;
		end >>= 12;
		if (start >= mmapLow.length)
			return;
		if (end >= mmapLow.length)
			end = mmapLow.length - 1;
		for (ulong idx = start; idx < end; idx++)
		{
			mmapLow[idx] = cast(ubyte) status;
		}
	}

	/// Returns the address of free 4KiB aligned block of memory and marks it allocated
	ulong mapPage()
	{
		foreach (i, ref v; mmapLow)
		{
			if (v == MapStatus.Free)
			{
				v = MapStatus.Allocated;
				return i * 4096;
			}
		}
		return 0xFFFF_FFFF_FFFF_0000;
	}

	void unmapPage(ulong addr)
	{
		addr >>= 12;
		if (addr >= mmapLow.length)
			return;
		if (mmapLow.ptr[addr] == MapStatus.Allocated)
		{
			mmapLow.ptr[addr] = MapStatus.Free;
		}
	}
}
