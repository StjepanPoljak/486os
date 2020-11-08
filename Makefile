PROJ=486os

CFLAGS = -mtune=i386 -Wall -ffreestanding -nostdinc -nostdlib -nostartfiles -Iinclude
LDFLAGS= -nostdlib -nostartfiles -melf_i386

objs = $(filter-out entry_S.o,$(filter-out boot_S.o,$(addsuffix _S.o,$(basename $(notdir $(wildcard source/*.S))))))
objs += $(addsuffix _c.o,$(basename $(notdir $(wildcard source/*.c))))

srcdir=source
incdir=include
builddir=build

all: $(builddir) $(PROJ).img

$(builddir):
	mkdir $(builddir)

$(builddir)/%_BS.o: $(srcdir)/%.S
	gcc -m16 $(CFLAGS) -c $< -o $@

$(builddir)/%_S.o: $(srcdir)/%.S
	gcc -m32 $(CFLAGS) -c $< -o $@

$(builddir)/%_c.o: $(srcdir)/%.c
	gcc -m32 $(CFLAGS) -c $< -o $@

$(builddir)/$(PROJ).elf: $(addprefix $(builddir)/,$(objs)) $(builddir)/boot_BS.o $(builddir)/entry_BS.o link.ld
	ld $(LDFLAGS) $(filter-out link.ld,$^) -T link.ld -o $@

$(PROJ).img: $(builddir)/$(PROJ).elf
	objcopy -O binary $< $@

run: $(PROJ).img
	qemu-system-i386 -cpu 486 -serial mon:stdio -drive file=486os.img,format=raw,media=disk

.PHONY=clean
clean:
	rm -rf $(PROJ).img $(builddir)

