.code16
.section .boot

ljmp $0x0, $_start

.globl _start
_start:
	cli

	/* GCC expects CS=SS=ES=DS */
	mov %cs, %ax
	mov %ax, %ss
	mov %ax, %ds
	mov $0x9000, %ax
	mov %ax, %es
	xor %bx, %bx

	mov _ld_early_stack, %sp
	
	sti

	movb %dl, dlsave

	mov $msg, %si
	call print_string

	push %es
	push %bx
	mov $0x02, %ah
	mov $1, %al
	xor %ch, %ch
	mov $2, %cl
	movb (dlsave), %dl
	xor %dh, %dh
	int $0x13

loop_read:
	mov %es:(%bx), %al
	cmp $0, %al
	je cont

	movb $0x0e, %ah
	int $0x10
	add $1, %bx
	jmp loop_read

cont:
	pop %bx
	pop %es

	ret

halt:
	cli
	hlt
	jmp halt

print_string:
	pusha

	xor %ax, %ax
	xor %bx, %bx
	xor %cx, %cx

print_string_loop:
	lodsb
	cmp $0, %al
	je print_string_end

	movb $0x0e, %ah
	int $0x10

	jmp print_string_loop

print_string_end:
	popa
	ret

msg:	.asciz "Hello world!\n\r"
dlsave: .byte 0
	.byte 0

.section .data

.asciz "You are now reading from the disk. Isn't that wonderful?\n\r"
