build: boot.s
	../../env/mk.sh

.PHONY: bochs
bochs:
	bochs -q -f ../../env/.bochsrc -rc ../../env/cmd.init

.PHONY: qemu
qemu:
	../../env/boot.sh

.PHONY: clean
clean:
	rm -rf *.lst *.img
