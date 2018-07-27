'''
/usr/bin/python
calculateVolume.py
'''

'''
formulas: 
volume of capsule tank  = πrˆ2((4/3)r + a)
volume of spherical cap = (1/3)πhˆ2(3R - h)

a = (length of tank) - (diameter of hemispheres)
r = 1/2 of diameter
'''

from math import pi

sphereRadius = float(input("Radius?: "))
cylinderHeight = float(input("Cylinder height?: "))

def calcVolume(sphereRadius, cylinderHeight):
	volume = (pi * (sphereRadius**sphereRadius)) * (((4/3) * sphereRadius) + cylinderHeight)
	print("Tank volume is: %f cubed feet" % round(volume, 4))

calcVolume(sphereRadius, cylinderHeight)
