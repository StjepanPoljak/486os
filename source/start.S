.code16
	mov $msg, %si

loop:
	lodsb
	cmp $0, %al
	je halt

	mov $0x0e, %ah
	int $0x10

	jmp loop
halt:
	hlt
msg:
	.asciz "Hello world!"
