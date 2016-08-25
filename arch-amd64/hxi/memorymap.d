module hxi.memorymap;

import barec;

enum HxiFixedAddress : ulong {
	KernelVMABase = 0xFFFF_8000_0000_0000,
	KernelAllocBase = 0xFFFF_F000_0000_0000,
	KernelRing0StacksBase = 0xFFFF_1000_0000_0000,
	KernelRing3StacksBase = 0xFFFF_1100_0000_0000,
}
