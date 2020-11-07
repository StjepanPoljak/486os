.code16
.section .entry
.globl kernel_entry
kernel_entry:

	mov %cs, %ax
	mov %ax, %es
	mov %ax, %ds
	mov %ax, %ss
	mov $0xFFF0, %sp

	mov $msg2, %si	
	call bios_print_string

.section .data

msg2: .asciz "You are now reading from the disk. Isn't that wonderful?\n\r"

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
