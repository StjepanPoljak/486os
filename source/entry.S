.code16
.section .entry
.globl kernel_entry
kernel_entry:

	mov	%cs, %ax
	mov	%ax, %es
	mov	%ax, %ds
	mov	%ax, %ss
	mov	$0xFFF0, %sp

	mov	$msg2, %si	
	call	bios_print_string

	mov	$msg3, %si
	call	bios_print_string

	xor	%ah, %ah
	int	$0x16

	mov	$0x3, %ax
	int	$0x10

	xor	%al, %al
	mov	_ld_bss_start, %bx
	mov	_ld_bss_end, %cx
bss_zero_loop:
	mov	%al, (%bx)
	add	$0x1, %bx
	cmp	%cx, %bx
	jne	bss_zero_loop

	cli
	lgdt	gdt_ptr
	mov	%cr0, %eax
	or	$0x1, %eax
	mov	%eax, %cr0
	ljmp	$0x10,$kmain	/* 0x10 points to code segment in gdt */

msg2: .asciz "You are now reading from the disk. Isn't that wonderful?\n\r"
msg3: .asciz "Press any key to continue..."

.section .gdt

.globl gdt_ptr
gdt_ptr:
	.word	0x1f
	.int	gdt

.align 16
.globl gdt
gdt:
	/* mandatory NULL entry */
	.quad 0x0

	/* unused descriptor */
	.quad 0x0

	/* code segment descriptor */
	.word 0xffff
	.word 0x0
	.byte 0x0
	.byte 0x9a
	.byte 0xcf
	.byte 0x00

	/* data segment descriptor */
	.word 0xffff
	.word 0x0000
	.byte 0x0
	.byte 0x92
	.byte 0xcf
	.byte 0x0
