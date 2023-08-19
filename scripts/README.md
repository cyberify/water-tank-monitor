# Scripts
### todo: update this

### `sensor_monitor.rb`
This is the master script. It is responsible for performing script actions, data collection, and database management. It is daemonized by CouchDB, and should be kept running at all times. The main thread is run periodically, waiting a given number of seconds between each loop. The interval can be set using the `ENV` variable `SENSOR_POLL_INTERVAL`.