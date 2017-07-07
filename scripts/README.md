# Scripts

### `getReading.py`
This script reads data directly from the serial port to which the external sensor is connected, using the `maxSonarTTY` module. When run, it prints a single measurement to `stdout` (distance in millimeters).

### `maxSonarTTY.py`
This python module is a 3rd party adapter for reading serial data from MaxBotix ultrasonic rangefinder sensors. It provides a method that returns one sensor reading as an `Integer` value.

### `sensor_monitor.rb`
This is the master script. It is responsible for performing script actions, data collection, and database management. It is daemonized by CouchDB, and should be kept running at all times. The main thread is run periodically, waiting a given number of seconds between each loop. The interval can be set using the `ENV` variable `SENSOR_POLL_INTERVAL`.

---
#### MaxBotix ultrasonic sensor

*TODO: add better minicom usage documentation*

Notes for tank pi:

- format: RS232 / TTL
- command: `minicom -b 9600 -o -D /dev/ttyAMA0`