/// Basic memory-related types and addresses.
module hxi.mem.memory;

import kstdlib;

/// Size of a single page
enum ulong PAGE_GRANULARITY = 0x1000;
/// The space reserved for early boot data.
enum ulong BOOT_RESERVED = 1.MB;
/// The memory mapped with the page tables set up during early boot.
enum ulong EARLY_MAPPED_MEMORY = 50.MB;
enum void* VIRTUAL_MAPPABLE_KSTART = cast(void*) 0xfffff00000000000;
enum void* VIRTUAL_MAPPABLE_KEND = cast(void*) 0xffffffffffff0000;
enum void* VIRTUAL_MAPPABLE_USTART = cast(void*) 0x0000000000200000;
enum void* VIRTUAL_MAPPABLE_UEND = cast(void*) 0x0000ffffffff0000;
///
alias PhysicalAddress = Typedef!(ulong, 0xFFFF_FFFF_FFFF_FFFFuL, "physaddr");
/// null PhysicalAddress
enum pnull = PhysicalAddress();
///
alias VirtualAddress(T = void) = T*;

PhysicalAddress kernelLocalSpaceToPhysical(T)(T* vaddr)
{
	ulong paddr = cast(ulong) vaddr;
	paddr &= ~cast(ulong) LinkerScript.kernelVMA;
	return PhysicalAddress(paddr);
}

VirtualAddress!T physicalSpaceToKernelLocal(T = void)(PhysicalAddress paddr)
{
	ulong vaddr = cast(ulong) paddr;
	vaddr |= cast(ulong) LinkerScript.kernelVMA;
	return cast(T*) vaddr;
}

/// 0xffffc00000000000+ - the physical mapped space
enum ulong PHMAP_OFFSET = 0xffffc00000000000UL;

PhysicalAddress phmapSpaceToPhysical(T)(T* vaddr)
{
	ulong paddr = cast(ulong) vaddr;
	paddr &= ~PHMAP_OFFSET;
	return PhysicalAddress(paddr);
}

VirtualAddress!T physicalSpaceToPhmap(T = void)(PhysicalAddress paddr)
{
	ulong vaddr = cast(ulong) paddr;
	vaddr |= PHMAP_OFFSET;
	return cast(T*) vaddr;
}

extern (C)
{
private:
__gshared:
	extern ubyte KERNEL_VMA;
	extern ubyte multiboot_start;
	extern ubyte multiboot_end;
	extern ubyte text_start;
	extern ubyte text_end;
	extern ubyte data_start;
	extern ubyte data_end;
	extern ubyte rodata_start;
	extern ubyte rodata_end;
	extern ubyte bss_start;
	extern ubyte bss_end;
	extern ubyte kernel_start;
	extern ubyte kernel_end;
	extern ubyte ehframe_start;
	extern ubyte ehframe_end;
}

struct LinkerScript
{
static:
public:
@nogc:
@trusted:
nothrow:

	void* kernelVMA()
	{
		return &KERNEL_VMA;
	}

	void* multibootStart()
	{
		return &multiboot_start;
	}

	void* multibootEnd()
	{
		return &multiboot_end;
	}

	void* textStart()
	{
		return &text_start;
	}

	void* textEnd()
	{
		return &text_end;
	}

	void* dataStart()
	{
		return &data_start;
	}

	void* dataEnd()
	{
		return &data_end;
	}

	void* rodataStart()
	{
		return &rodata_start;
	}

	void* rodataEnd()
	{
		return &rodata_end;
	}

	void* bssStart()
	{
		return &bss_start;
	}

	void* bssEnd()
	{
		return &bss_end;
	}

	void* ehframeStart()
	{
		return &ehframe_start;
	}

	void* ehframeEnd()
	{
		return &ehframe_end;
	}

	void* kernelStart()
	{
		return &kernel_start;
	}

	void* kernelEnd()
	{
		return &kernel_end;
	}
}
