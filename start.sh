#!/bin/bash

qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 rootfstype=ext4 elevator=deadline rootwait panic=1" -hda rpi_fun.img -redir tcp:2222::22
