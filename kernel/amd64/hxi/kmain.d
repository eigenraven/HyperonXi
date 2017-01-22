module hxi.kmain;

import kstdlib;
import multiboot;
import hxi.kernel;

nothrow:
@nogc:

extern (C) void kmain_multiboot(long magicNumber, void* bootData)
{
	if (magicNumber != MULTIBOOT2_BOOTLOADER_MAGIC)
		abort();
	if (bootData is null)
		abort();
	cpuid_init();
	TheKernel.vtable.InitializeEarly(&TheKernel);
	while (1)
	{
		asm nothrow @nogc
		{
			cli;
			hlt;
		}
	}
}
