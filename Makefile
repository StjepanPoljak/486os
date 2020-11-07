PROJ=486os

CFLAGS = -m32 -mtune=i386 -Wall -ffreestanding -nostdinc -nostdlib -nostartfiles -Iinclude
LDFLAGS= -nostdlib -nostartfiles -melf_i386

objs=$(addsuffix _S.o,$(basename $(notdir $(wildcard source/*.S))))

srcdir=source
incdir=include
builddir=build

all: $(builddir) $(PROJ).img

$(builddir):
	mkdir $(builddir)

$(builddir)/%_S.o: $(srcdir)/%.S
	gcc $(CFLAGS) -c $< -o $@

$(builddir)/$(PROJ).elf: $(addprefix $(builddir)/,$(objs)) link.ld
	ld $(LDFLAGS) $(filter-out link.ld,$^) -T link.ld -o $@

$(PROJ).img: $(builddir)/$(PROJ).elf
	objcopy -O binary $< $@

run: $(PROJ).img
	qemu-system-i386 -cpu 486 -serial mon:stdio -drive file=486os.img,format=raw,media=disk

.PHONY=clean
clean:
	rm -rf $(PROJ).img $(builddir)

