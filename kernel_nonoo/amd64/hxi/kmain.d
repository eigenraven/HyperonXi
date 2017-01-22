module hxi.kmain;

import kstdlib;
import multiboot;
import hxi.log;
import hxi.serial;
import hxi.mem.memory;
import hxi.mem.physical_allocator;
import hxi.mem.paging;
import hxi.mem.virtual_allocator;
import hxi.cpu.descriptors;
import hxi.cpu.interrupts;
import hxi.cpu.ps2;
import hxi.fbcon.framebuffer;

nothrow:
@nogc:

void setupMMap(void* bootData)
{
	MemoryMapEntry[] entries = physicalSpaceToPhmap!MemoryMapEntry(allocateZeroedPhysicalPage())[0
		.. PAGE_GRANULARITY / MemoryMapEntry.sizeof];
	int i = 0;
	ulong total = 0;
	foreach (multiboot_tag* tag; iterateMultibootTags(bootData))
	{
		if (tag.type == MULTIBOOT_TAG_TYPE_MMAP)
		{
			multiboot_tag_mmap* map = cast(multiboot_tag_mmap*) tag;
			ubyte* it;
			ubyte* end = (cast(ubyte*) map) + map.size;
			for (it = cast(ubyte*) map.entries.ptr; it != end; it += map.entry_size)
			{
				if (i > 0)
					entries[i - 1].next = &entries[i];
				if (i >= entries.length)
					break;
				multiboot_mmap_entry* E = cast(multiboot_mmap_entry*) it;
				entries[i].start = PhysicalAddress(E.addr);
				entries[i].length = E.len;
				entries[i].type = E.type;
				if (E.type == 1)
					total += E.len;
				logf(LogLevel.Trace, "Memory: %b (len %b) T%d", E.addr, E.len, E.type);
				i++;
			}
			break;
		}
	}
	memoryMapHead = entries.ptr;
	logf(LogLevel.Trace, "Memory map OK, contains %d entries", i);
	logf(LogLevel.Info, "Available physical memory: %b", total);
}

/// Main function when booted through the multiboot2 image
extern (C) void kmain_multiboot(long magicNumber, void* bootData)
{
	if (magicNumber != MULTIBOOT2_BOOTLOADER_MAGIC)
		abort();
	if (bootData is null)
		abort();
	bootData = physicalSpaceToPhmap(cast(PhysicalAddress) cast(ulong) bootData);

	cpuid_init();
	setupLogging();
	setupSerialDebugPort();
	logf(LogLevel.Info, "HyperonXi early setup phase, magic: 0x%x, bootData: 0x%x",
			magicNumber, cast(ulong) bootData);
	// Bootstrap physical memory allocator with 50MB of memory
	setupEarlyPhysicalAllocator();
	log(LogLevel.Trace, "Early physical allocator OK");
	// Read the memory map from multiboot structures
	setupMMap(bootData);
	logf(LogLevel.Trace, "Mmap head: %x", cast(ulong) memoryMapHead);
	// Build the new page tables.
	setupPaging();
	log(LogLevel.Trace, "Page table OK");
	setupLatePhysicalAllocator();
	log(LogLevel.Trace, "Late physical allocator OK");
	setupVirtualAllocator();
	log(LogLevel.Trace, "Virtual allocator OK");
	// Create the framebuffer
	multiboot_tag_framebuffer* fbtag;
	foreach (multiboot_tag* tag; iterateMultibootTags(bootData))
	{
		if (tag.type == MULTIBOOT_TAG_TYPE_FRAMEBUFFER)
			fbtag = cast(multiboot_tag_framebuffer*) tag;
	}
	Framebuffer fbcon = Framebuffer(fbtag);
	fbcon.clear(0);
	fbcon.printString("HyperionXi graphical framebuffer initialized.\n");

	setupCpuDescriptorTables();
	log(LogLevel.Trace, "Reloaded descriptors OK");
	initializeInterrupts();
	log(LogLevel.Trace, "Interrupts OK");
	PS2Controller.setup();
	log(LogLevel.Trace, "8042 PS/2 controller OK");

	criticalFailure();
}
