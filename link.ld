SECTIONS{
	. = 0x7c00;
	.text : {
		*(.text)
		. = 510;
		SHORT(0xAA55)
	}
}
