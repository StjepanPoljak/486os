.code16
.section .boot

.globl _start
_start:
	xor %eax, %eax

	/* GCC expects SS=ES=DS */
	mov %ax, %ss
	mov %ax, %es
	mov %ax, %ds
	mov _ld_early_stack, %sp

	mov $msg, %si
	call print_string

	cli
	hlt

print_string:
	push %ax

print_string_loop:
	lodsb
	cmp $0, %al
	je print_string_end

	movb $0x0e, %ah
	int $0x10

	jmp print_string_loop

print_string_end:
	pop %ax
	ret

msg:	.asciz "Hello world!\n\r"
