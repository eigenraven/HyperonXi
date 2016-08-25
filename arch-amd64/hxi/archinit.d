module hxi.archinit;

import hxi.multiboot;
import hxi.linker;
import hxi.memory.allocators;
import hxi.memory.paging;
import hxi.drivers.cpudt;
import hxi.drivers.interrupts;

version (X86_64)
{
}
else
{
    static assert(0, "AMD64 tree cannot be compiled for this architecture");
}

/// Initialize before vmem
void hxiArchInitZero(void* bootdata) nothrow @nogc
{
}

/// Initialize with framebuffer, debugging port, etc...
void hxiArchInit(void* bootdata) nothrow @nogc
{
    initializeCpuDT();
    initializeInterrupts();
}
