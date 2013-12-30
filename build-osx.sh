#!/bin/bash

gcc -I/System/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -c -o xxmodule.o xxmodule.c
gcc -dynamiclib -Wl,-headerpad_max_install_names,-undefined,dynamic_lookup,-compatibility_version,1.0,-current_version,1.0,-install_name,/usr/local/lib/xxmodule.so -o xxmodule.so xxmodule.o
