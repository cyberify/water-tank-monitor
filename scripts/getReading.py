#!/usr/bin/python3
#
import maxSonarTTY

serialPort = "/dev/ttyAMA0"
maxRange = 2438 # Length of the tank and manhole, in millimeters
minMM = 9999
maxMM = 0

print(maxSonarTTY.measure(serialPort))
