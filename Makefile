%.o: %.cpp
        g++ -m32 -o $@ -c $<

%.o: %.s
        as --32 -o $@ $<

mykernel.bin: linker.ld loader.o kernel.o
        ld -melf_i386 -T $< -o $@ loader.o kernel.o

install: mykernel.bin
        sudo cp $< /boot/mykernel.bin

mykernel.iso: mykernel.bin
        mkdir iso
        mkdir iso/boot
        mkdir iso/boot/grub
        cp $< iso/boot/
        echo 'set timeout=0' >> iso/boot/grub/grub.cfg
        echo 'set default=0' >> iso/boot/grub/grub.cfg
        echo '' >> iso/boot/grub/grub.cfg
        echo 'menuentry "Suman Operating System" {' >> iso/boot/grub/grub.cfg
        echo ' multiboot /boot/mykernel.bin' >> iso/boot/grub/grub.cfg
        echo ' boot' >> iso/boot/grub/grub.cfg
        echo '}' >> iso/boot/grub/grub.cfg
