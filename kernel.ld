OUTPUT_FORMAT(elf64-x86-64)
ENTRY(pstubentry)

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

	.data : AT(ADDR(.data) - KERNEL_VMA) {
		data_start = .;
		KEEP( *(.data*) )
		. = ALIGN(8);
		ctors_array_start = . ;
		KEEP( *(.ctors) )
		KEEP( *(.ctors*) )
		ctors_array_end = . ;
		dtors_array_start = . ;
		KEEP( *(.dtors) )
		KEEP( *(.dtors*) )
		dtors_array_end = . ;
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
	
	kernel_end = .;
	. = ALIGN(2M);
	kernel_end_2m = .;
	/DISCARD/ :
	{
		*(.comment)
	}
}
