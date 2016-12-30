
OUTPUT_FORMAT(elf64-x86-64)
ENTRY(abort)

SECTIONS
{

	. = 0x10000;
	.multiboot : {
		multiboot_start = .;
		KEEP( *(.multiboot) )
		multiboot_end = .;
	}

	KERNEL_VMA = 0xFFFF800000000000;
	. = KERNEL_VMA + multiboot_end;
	
	.text : AT(ADDR(.text) - KERNEL_VMA) {
		. = ALIGN(4096);
		kernel_start = .;
		text_start = .;
		KEEP( *(.text*) )
		KEEP( *(.rodata*) )
		. = ALIGN(4096);
		text_end = .;
	}
	
	.eh_frame : AT(ADDR(.eh_frame) - KERNEL_VMA) {
		ehframe_start = .;
		KEEP( *(.eh_frame) )
		. = ALIGN(4096);
		ehframe_end = .;
	}

	.rodata : AT(ADDR(.rodata) - KERNEL_VMA) {
		rodata_start = .;
		KEEP( *(.rodata*) )
		. = ALIGN(4096);
		rodata_end = .;
	}

	.data : AT(ADDR(.data) - KERNEL_VMA) {
		data_start = .;
		KEEP( *(.data*) )
		. = ALIGN(8);
		KEEP( *(.ctors) )
		KEEP( *(.ctors*) )
		KEEP( *(.dtors) )
		KEEP( *(.dtors*) )
		KEEP( *(.minfo_beg) )
		KEEP( *(.minfo) )
		KEEP( *(.minfo_end) )
		. = ALIGN(4096);
		data_end = .;
	}

	.bss : AT(ADDR(.bss) - KERNEL_VMA) {
		bss_start = .;
		KEEP( *(.dynbss*) )
		KEEP( *(.bss*) )
		KEEP( *(COMMON) )
		. = ALIGN(4096);
		bss_end = .;
	}
	
	. = ALIGN(4096);
	kernel_end = .;
	/DISCARD/ :
	{
		*(.comment)
	}
}
