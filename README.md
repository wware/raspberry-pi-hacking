Emulating an RPi in QEMU
-

The goal here is to prepare a Raspian-based image for some intended purpose in
QEMU and `dd` it to the SD card, so you don't need to develop on the RPi itself
if you don't want to.

Here is where I started:

* https://github.com/psema4/pine/wiki/Installing-QEMU-on-OS-X

I needed to use a different kernel from the one recommended there, because I got
SCSI aborts and weirdness. So the kernel I used is at

* http://keirthomas.com/dump/kernel-qemu

and its MD5 is `88705be8e3a465113d700a6116536a3b`.

That worked til we get to the rootfs, which is Ubuntu, not Raspbian. The kernel
image was fine. After banging on a few other sources like these:

* http://darranboyd.wordpress.com/2013/08/20/virtualize-raspberry-pi-i-e-arm-on-os-x-using-qemu/
* http://www.linux-mitterteich.de/fileadmin/datafile/papers/2013/qemu_raspiemu_lug_18_sep_2013.pdf
* http://www.cnx-software.com/2011/10/18/using-raspberry-pi-as-an-internet-kiosk/

The results of all that was the `start.sh`, `stop.sh` and `initial-boot.sh` scripts.

Starting with a vanilla Raspbian image, following instructions in the PDF,
expand the filesystem. Then use the `initial-boot.sh` script to do a couple of
steps, see "Boot to root shell and fix some stuff", basically comment out the
contents of /etc/ld.so.preload, and create `/etc/udev/rules.d/90-qemu.rules`,
and run `sync`. Then boot into the normal user shell using the `start.sh`
script, and do the raspi-config stuff.

Then you want to `apt-get update; apt-get upgrade`. That will be very slow
going and might need to run overnight. Each time you run QEMU on an image
file, the image is updated.

Some ideas about how to do a RPi thermostat
-

Set up a server on Heroku with HTTPS endpoints
(http://flask.pocoo.org/snippets/111/). You POST and receive JSON.
Authentication depends upon finding a known long random-like string in the
JSON, on a known key. That should be OK security-wise as long as you trust
HTTPS.

The RPi hits an endpoint to which it provides the current temperature, and it
gets back a control signal saying whether or not the heat should be on. This is
done once every five minutes.

The Heroku thing maintains a database containing the temperature you want. Log
temperatures and control signals over time and see how things are working.
