#!/bin/sh

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build!"
	exit
fi

rm -rf tmp

clear

echo "> Creating tmp folder..."
mkdir tmp

echo "> Compiling Assembly..."
cd boot
nasm bootloader.asm -f bin -o ../bin/bootloader.bin
cd ../kernel
nasm kernel_entry.asm -f elf64 -o ../tmp/kernel_entry.o

echo "> Compiling C code..."
gcc -w -ffreestanding -c kernel.c -o ../tmp/kernel.o
gcc -w -ffreestanding -c drivers/screen.c -o ../tmp/screen.o
gcc -w -ffreestanding -c drivers/io.c -o ../tmp/io.o

echo "> Linking C code..."
cd ../tmp
ld  -s -o ../bin/kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o screen.o io.o --oformat binary -entry main 

echo "> Creating image..."
cd ../bin
cat bootloader.bin kernel.bin > ../image/king

cd ../
echo "> Removing tmp folder..."
rm -rf tmp

echo "> Running..."
qemu-system-x86_64 ./image/king
