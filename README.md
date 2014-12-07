Bitbaking for the RPi
=

I started with these [instructions](http://www.cnx-software.com/2013/07/05/12mb-minimal-image-for-raspberry-pi-using-the-yocto-project/).
I did need to install some SDL stuff in order to get the build to succeed. Otherwise I followed the procedure pretty closely.

```bash
sudo apt-get install -y libsdl1.2debian libsdl1.2-dbg libsdl1.2-dev
```

The resulting binary is now on the SD card in the RPi B+ and I'll test it when I get home.

So this worked fine. Just like the system at work, you end up with a command line
system with root as the only user and no password. The minimum image does not
include the openssh server, so that should be added. But this is going to make
a lot of my projects much much simpler.

Give some thought to some kind of script that painlessly packages stuff up into
a Yocto package. There would probably be variants for different kinds of
projects, v like ones that only include static files versus ones where am
executable must be built. Things can probably be described by a JSON or YAML
file.

Project ideas
=

Web-accessible thermostat
-

Set up a server on Heroku with [HTTPS endpoints](http://flask.pocoo.org/snippets/111/).
You POST and receive JSON. Authentication depends upon finding a known long
random-like string in the JSON, on a known key. That should be OK security-wise
as long as you trust HTTPS.

The RPi interacts with the server to fetch the setpoint and report the current
temperature. The setpoint is settable in the browser if you're logged in, and
you can see a log of setpoints and current temps, sampled every 20 or 30 minutes.

Remote GDB machine
-

The idea here is to replicate the functionality that was provided for the 6502 in the
KIM-1 board of the late 1970s. It had a hexadecimal keypad and 7-segment LED displays
for an address and data. You could enter a program one byte at a time and then run it,
and if memory serves you could single-step it.

Nowdays keypads and 7-segment displays are unnecessary because we have laptops and
tablets, so the UI could either be [GDB running remotely](http://en.wikipedia.org/wiki/Gdbserver)
(also see (StackOverflow)[http://stackoverflow.com/questions/3512961/remote-gdb-debugging])
or a web UI. That could possibly be done with libmigdb, or maybe just wiring up stdin and
stdout of a GDB process to web interface.

Emulating an RPi in QEMU
=

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

.. \_

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

