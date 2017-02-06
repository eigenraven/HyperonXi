module hxi.kmain;

import kstdlib;
import multiboot;
import hxi.kernel;
import hxi.log;
import hxi.cpu.rs232logger;

nothrow:
@nogc:

extern (C) void kmain_multiboot(long magicNumber, void* bootData)
{
	if (magicNumber != MULTIBOOT2_BOOTLOADER_MAGIC)
		abort();
	if (bootData is null)
		abort();
	cpuid_init();
	Kernel* kernel = &TheKernel;
	kernel.vtable.InitializeEarly(kernel);
	kernel.log = &TheLog;
	setupDebugLogging(kernel);
	klog(kernel.log, LogLevel.Info, "Early logging initialized.");
	while (1)
	{
		asm nothrow @nogc
		{
			cli;
			hlt;
		}
	}
}
