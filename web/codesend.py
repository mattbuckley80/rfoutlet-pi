#!/usr/bin/env python3
# codesend.py — RF outlet transmitter for Raspberry Pi 4/5
# Replaces the original codesend binary which had GPIO timing issues on Pi 4/5
# Uses rpi-rf + rpi-lgpio for Pi 4/5 compatible GPIO access
#
# Usage: python3 codesend.py <code> <pulse_length> <gpio_pin>
# Example: python3 codesend.py 4527411 189 17

import sys
import os

# Change to /tmp before importing lgpio
# lgpio creates a notification file in the current directory
# Apache's www-data user can't write to /var/www/html/rfoutlet/
# but can always write to /tmp
os.chdir('/tmp')

from rpi_rf import RFDevice

code = int(sys.argv[1])
pulse = int(sys.argv[2])
pin = int(sys.argv[3])

rfdevice = RFDevice(pin)
rfdevice.enable_tx()
rfdevice.tx_code(code, 1, pulse)
rfdevice.cleanup()
