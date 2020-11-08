OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY (_start)

SECTIONS {
	. = 0x7c00;
	_ld_early_stack = .;
	.boot : {
		*(.boot)
		. = 510;
		SHORT(0xAA55)
		*(.entry)
		. = ALIGN(16);
		*(.gdt)
	}
	. = ALIGN(16);
	.text : {
		*(.text)
	}
	. = ALIGN(16);
	.data : {
		*(.data); *(.rodata)

	}
	. = ALIGN(16);
	.bss : {
		_ld_bss_start = .;
		*(.bss)
		_ld_bss_end = .;
	}
}
