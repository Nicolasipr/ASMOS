#!/bin/sh

# This script assembles the MikeOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

# (If you need to blank the floppy image: 'mkdosfs disk_images/ASMOS.flp')


if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e 07-disk_images/ASMOS.flp ]
then
	echo ">>> Creating new MikeOS floppy image..."
	mkdosfs -C 07-disk_images/ASMOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o 00-boot/boot.bin 00-boot/boot.asm || exit


echo ">>> Assembling MikeOS kernel..."


nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit



echo ">>> Assembling programs..."

cd 04-Software

for i in *.asm
do
	nasm -O0 -w+orphan-labels -f bin $i -o `basename $i .asm`.bin || exit
done

cd ..


echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=00-boot/boot.bin of=07-disk_images/ASMOS.flp || exit


echo ">>> Copying ASMOS kernel and programs..."
ls

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat 07-disk_images/ASMOS.flp tmp-loop && cp kernel.bin tmp-loop/

cp 04-Software/*.bin 04-Software/*.bas 04-Software/sample.pcx tmp-loop

sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop


echo ">>> Creating CD-ROM ISO image..."

rm -f disk_images/mikeos.iso
mkisofs -quiet -V 'ASMOS' -input-charset iso8859-1 -o 07-disk_images/ASMOS.iso -b ASMOS.flp disk_images/ || exit

echo '>>> Done!'
