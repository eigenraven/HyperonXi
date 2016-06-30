module hxi.linker;

extern (C)
{
	__gshared:
	extern ubyte KERNEL_VMA;
	extern ubyte multiboot_start;
	extern ubyte multiboot_end;
	extern ubyte text_start;
	extern ubyte text_end;
	extern ubyte data_start;
	extern ubyte data_end;
	extern ubyte bss_start;
	extern ubyte bss_end;
	extern ubyte kernel_end;
	extern ubyte kernel_end_2m;
	extern ubyte ctors_array_start;
	extern ubyte ctors_array_end;
	extern ubyte dtors_array_start;
	extern ubyte dtors_array_end;
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

	void* bssStart()
	{
		return &bss_start;
	}

	void* bssEnd()
	{
		return &bss_end;
	}

	void* kernelEnd()
	{
		return &kernel_end;
	}
	
	void* kernelEnd2M()
	{
		return &kernel_end_2m;
	}

	void* ctorsArrayStart()
	{
		return &ctors_array_start;
	}

	void* ctorsArrayEnd()
	{
		return &ctors_array_end;
	}

	void* dtorsArrayStart()
	{
		return &dtors_array_start;
	}

	void* dtorsArrayEnd()
	{
		return &dtors_array_end;
	}
}
