#!/usr/bin/python3

# Copyright (C) 2024 Robert Hancock
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author: Robert Hancock
# https://github.com/cyberify

import time
import busio
import board
from digitalio import DigitalInOut
import adafruit_rfm69


i2c = busio.I2C(board.SCL, board.SDA)
CS = DigitalInOut(board.CE1)
RESET = DigitalInOut(board.D25)
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
rfm69 = adafruit_rfm69.RFM69(spi, CS, RESET, 915.0)
rfm69.encryption_key = ''
packet = None

while packet is None:
    packet = rfm69.receive()
    time.sleep(0.25)

pckt = str(packet)

beginning = pckt.index('R')
# Get index of first '\' in data stream
end = pckt.index('\\', beginning)
# Get distance reading value between 'R' and '\'
pcktVal = int(pckt[(beginning + 1):end])

print(pcktVal, sep="")
