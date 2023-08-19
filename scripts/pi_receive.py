#!/usr/bin/python3

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

packetText = str(packet, "utf-8")
print(packetText)