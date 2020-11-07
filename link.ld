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
	}
	.text : {
		*(.entry); *(.text)
	}
	.data : {
		*(.gdt); *(.data); *(.rodata)
		SHORT(0x0000)

	}
}
