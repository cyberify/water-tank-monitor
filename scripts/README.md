# Scripts
### `monitor.rb`
This is the master script. It is responsible for all data collection and database management. Daemonized  using 
`systemd`.
  
### `pi_receive.py`
Listen continually for radio data and return just the water tank level in milimeters. 
  
### `feather_receive.py`
Not used. 

### `feather_transmit.py`
Poll the ultrasonic sensor every 0.5 seconds and broadcast the water level data with the radio.

### `notify_group.sh`
This shell script notifies a telegram group chat with provided chat ID, using a bot with a specified token, a message provided as an in-line argument.