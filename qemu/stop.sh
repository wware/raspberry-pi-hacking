#!/bin/bash

kill -9 $(ps ax | grep qemu | cut -c -6)
