#!/usr/bin/env python

import time
import xx

for i in range(5):
    xx.gpio(-1)
    time.sleep(0.25)
    xx.gpio(0)
    time.sleep(0.25)
