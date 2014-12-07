#!/bin/bash

rm -f xxmodule.o xxmodule.so
gcc -I/usr/include/python2.7 -c -o xxmodule.o xxmodule.c || exit 1
gcc -shared -Wl,-soname,xxmodule.so -o xxmodule.so xxmodule.o /usr/lib/libpython2.7.a
