# Written by Robert Hancock III, with some code taken from Adafruit
# To visualize data received from the property's water tank on an in-house display unit

import board, busio, digitalio, adafruit_rfm69
from time import sleep
from math import floor
from adafruit_ht16k33.bargraph import Bicolor24
import adafruit_ht16k33.segments

# Radio Setup
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
cs = digitalio.DigitalInOut(board.RFM69_CS)
reset = digitalio.DigitalInOut(board.RFM69_RST)
rfm69 = adafruit_rfm69.RFM69(spi, cs, reset, 915.0)
rfm69.encryption_key = ''

# Display Setup
i2c = board.I2C()
# 24 Segment Bargraph
bg = Bicolor24(i2c, address=0x72)
# Alphanumeric display
dsply = adafruit_ht16k33.segments.Seg14x4(i2c, address=0x70, brightness=0.75)

# To display water level on segment display
def drawLevel(level):
    if level == "wait":
        bg.fill(bg.LED_YELLOW)
        runs=0

        while runs <= 2:
            for i in range(22, 0, -1):
                values = [i-1, i, i+1]

                for x in values:
                    bg[x] = bg.LED_OFF

                sleep(0.003)
                bg[i+2] = bg.LED_YELLOW

            for i in range(1, 23, 1):
                values = [i-1, i, i+1]

                for x in values:
                    bg[x] = bg.LED_OFF

                sleep(0.003)
                bg[i-2] = bg.LED_YELLOW

            runs+=1

        bg.fill(bg.LED_OFF)

    else:
        # 24 segments divided by max water level of 7.5ft = 3.2,
        # slightly higher value to ensure full display gets used
        ledSegments = floor(level*3.25)
        if level <= 2.5:
            color = bg.LED_RED
        elif level < 4.99:
            color = bg.LED_YELLOW
        else:
            color = bg.LED_GREEN
        # Reset display
        bg.fill(bg.LED_OFF)
        # Loop for coloring, display placed upside down
        for i in range(23, (23-ledSegments), -1):
            bg[i] = color

# To calculate fill level in feet
def getLevel(level):
    # Distance between max fill level and actual fill level,
    # accounting for sensor placement of 1.6ft
    correctedDistanceValue = level - 490
    # Max fill level is 7'5"
    rawWaterLevel = 2286 - correctedDistanceValue
    # Convert mm to feet
    waterLevel = rawWaterLevel / 304.8
    return(waterLevel)

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
        drawLevel(waterLevel)

    else:
        print("Waiting for signal..")
        drawLevel("wait")

    sleep(10)
