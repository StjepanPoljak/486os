.code16
.section .boot

/* make sure CS is properly set */
ljmp	$0x0, $_start

.globl _start
_start:
	cli

	/* GCC expects CS=SS=ES=DS */
	mov	%cs, %ax
	mov	%ax, %ss
	mov	%ax, %ds
	mov	%ax, %es
	xor	%bx, %bx

	mov	_ld_early_stack, %sp
	movb	%dl, drive

	sti

	mov	$msg, %si
	call	bios_print_string

	xor	%bx, %bx
	mov	%bx, %es

	movw	$kernel_entry, %bx
	movb	(_ld_total_sectors), %al
	movb	(start_sector), %cl
	
	movb	(drive), %dl
	xor	%dh, %dh	/* head 0 */
	xor	%ch, %ch	/* cylinder 0 */

	mov	$0x02, %ah
	int	$0x13

	ljmp	$0x0,$kernel_entry

halt:
	cli
	hlt
	jmp	halt

.globl bios_print_string
bios_print_string:
	pusha

	xor	%ax, %ax
	xor	%bx, %bx
	xor	%cx, %cx

bios_print_string_loop:
	lodsb
	cmp	$0, %al
	je	bios_print_string_end

	movb	$0x0e, %ah
	int	$0x10

	jmp	bios_print_string_loop

bios_print_string_end:
	popa
	ret

msg:		.asciz "Hello world!\n\r"
drive:		.byte 0
start_sector:	.byte 2
