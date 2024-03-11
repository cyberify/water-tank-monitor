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

# Written by Robert Hancock III, with some code taken from Adafruit
# To visualize data received from the property's water tank on an in-house display unit

import board, busio, digitalio, adafruit_rfm69
from time import sleep
from math import floor
import adafruit_ht16k33.segments

# Radio Setup
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
cs = digitalio.DigitalInOut(board.RFM69_CS)
reset = digitalio.DigitalInOut(board.RFM69_RST)
rfm69 = adafruit_rfm69.RFM69(spi, cs, reset, 915.0)
rfm69.encryption_key = ''

# Display Setup
i2c = board.I2C()
# Alphanumeric display
dsply = adafruit_ht16k33.segments.Seg14x4(i2c, address=0x70, brightness=0.75)


# To calculate fill level in feet
def getLevel(level):
    # Distance between max fill level and actual fill level,
    # accounting for sensor placement of 1.6ft
    #correctedDistanceValue = level - 490
    # Max fill level is 7'5"
    #rawWaterLevel = 2286 - correctedDistanceValue
    # Convert mm to feet
    #waterLevel = rawWaterLevel / 304.8
    waterLevel = 2743.2 - level
    cnvtdWaterLevel = (waterLevel * 0.00328084)
    return(cnvtdWaterLevel)

while True:
    # Try and receive value
    pckt = rfm69.receive()

    # Wait until non-empty packet received
    if pckt is not None:
        pckt = str(pckt)
        # Get index of the first 'R' in data stream
        beginning = pckt.index('R')
        # Get index of first '\' in data stream
        end = pckt.index('\\', beginning)
        # Get distance reading value between 'R' and '\'
        pcktVal = int(pckt[(beginning + 1):end])

        waterLevel = getLevel(pcktVal)

        # Output extended value to serial console
        print(waterLevel)

        # Clear both displays and print values
        dsply.print("    ")
        dsply.show()
        dsply.print(str(round(waterLevel, 3))[:-1] + 'F')
        dsply.show()

    else:
        print("Waiting for signal..")

    sleep(10)
