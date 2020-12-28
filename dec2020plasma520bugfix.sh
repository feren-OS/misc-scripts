#!/bin/bash

if [ ! -d $1 ]; then
    echo "We couldn't find the mounted Feren OS partition in the directory you supplied this command. Aborting now."
    exit 1
fi

cd "$1"
sudo rm -rf plasmafixdebs /plasmafixdebs
sudo mkdir plasmafixdebs
sudo ln -sf $(pwd)/plasmafixdebs /plasmafixdebs
sudo apt update
cd plasmafixdebs
sudo apt download libqt5core5a plasma-workspace

if [ ! $? -eq 0 ]; then
    echo "Unable to download required packages. Make sure you're connected to the internet. Aborting now."
    exit 1
fi

for i in /dev /dev/pts /proc /sys; do sudo mount -B $i "$1$i"; done
sudo mount /dev/sdb1 "$1/boot/efi"

sudo chroot "$1" dpkg --purge --force-all feren-patched-kcmlookandfeel
sudo chroot "$1" dpkg -i /plasmafixdebs/*.deb

for i in /dev/pts /dev /proc /sys /boot/efi; do sudo umount "$1$i" ; done

sudo rm -rf plasmafixdebs /plasmafixdebs

echo "Done. The issue should hopefully now be fixed."
