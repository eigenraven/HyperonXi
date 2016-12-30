/// Physical memory allocator
module hxi.mem.physical_allocator;

import kstdlib;
import hxi.mem.memory;

nothrow:
@nogc:

struct MemoryMapEntry
{
	PhysicalAddress start;
	ulong length;
	ulong type; /// 1 = free memory
	MemoryMapEntry* next;

	bool isFree()
	{
		return type == 1;
	}
}

__gshared MemoryMapEntry* memoryMapHead;

// PAGE_GRANULARITY
private struct FreeStackCell
{
	PhysicalAddress[PAGE_GRANULARITY / PhysicalAddress.sizeof - 1] stack;
	FreeStackCell* prevTable;
}

private __gshared align(4096) FreeStackCell firstStack = void;
/// Points to the top element of the stack.
private __gshared uint stackHead;
/// ditto
private __gshared FreeStackCell* stackHeadFrame;

private void pushFreeAddr(PhysicalAddress addr) @trusted
{
	if (stackHeadFrame is null || stackHead + 1 == stackHeadFrame.stack.length)
	{
		stackHead = 0;
		FreeStackCell* newCell = physicalSpaceToPhmap!FreeStackCell(addr);
		newCell.prevTable = stackHeadFrame;
		stackHeadFrame = newCell;
	}
	else
		stackHead++;
	stackHeadFrame.stack[stackHead] = addr;
}

private PhysicalAddress popFreeAddr() @trusted
{
	if (stackHeadFrame is null)
		return pnull;
	PhysicalAddress addr = stackHeadFrame.stack[stackHead];
	if (stackHead == 0)
	{
		stackHeadFrame = stackHeadFrame.prevTable;
		stackHead = cast(uint) stackHeadFrame.stack.length - 1;
	}
	else
	{
		stackHead--;
	}
	return addr;
}

/// Sets up a few pages for allocation in order to bootstrap the virtual memory allocator.
/// Maps the range (kernelEnd, EARLY_MAPPED_MEMORY) as free memory.
void setupEarlyPhysicalAllocator()
{
	firstStack.prevTable = null;
	firstStack.stack[0] = kernelLocalSpaceToPhysical(&firstStack);
	stackHead = 0;
	stackHeadFrame = &firstStack;

	immutable PhysicalAddress kend = cast(PhysicalAddress)((kernelLocalSpaceToPhysical(
			LinkerScript.kernelEnd) + PAGE_GRANULARITY - 1L) & ~(PAGE_GRANULARITY - 1L));
	for (PhysicalAddress addr = kend; addr < EARLY_MAPPED_MEMORY; addr += PAGE_GRANULARITY)
	{
		pushFreeAddr(addr);
	}
}

void setupLatePhysicalAllocator()
{
	for (MemoryMapEntry* entry = memoryMapHead; entry !is null; entry = entry.next)
	{
		if (entry.type != 1)
			continue;
		ulong end = entry.start + entry.length;
		if (end > EARLY_MAPPED_MEMORY)
		{
			ulong start = max(EARLY_MAPPED_MEMORY, cast(ulong) entry.start);
			start = (start + PAGE_GRANULARITY - 1L) & ~(PAGE_GRANULARITY - 1L);
			end = end & ~(PAGE_GRANULARITY - 1L);
			for (ulong A = start; A < end; A += PAGE_GRANULARITY)
			{
				pushFreeAddr(PhysicalAddress(A));
			}
		}
	}
}

PhysicalAddress allocatePhysicalPage()
{
	return popFreeAddr();
}

PhysicalAddress allocateZeroedPhysicalPage()
{
	PhysicalAddress addr = popFreeAddr();
	ulong[] vaddr = physicalSpaceToPhmap!ulong(addr)[0 .. PAGE_GRANULARITY / ulong.sizeof];
	vaddr[] = 0;
	return addr;
}

void freePhysicalPage(PhysicalAddress addr)
{
	addr &= ~(PAGE_GRANULARITY - 1L);
	pushFreeAddr(addr);
}
