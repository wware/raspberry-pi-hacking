#!/bin/bash

qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 init=/bin/sh rw" -hda rpi_fun.img
