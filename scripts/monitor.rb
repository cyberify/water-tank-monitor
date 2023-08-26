#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under cron (/etc/crontab)
#
require 'httparty'
require 'time'

# Database connection (SLEEP IS IMPORTANT, AS CouchDB ISN'T IMMEDIATELY UP
sleep 5
DB_SERVER = 'http://127.0.0.1:5984'
class CouchDB
  include HTTParty
  base_uri DB_SERVER
  format :json
  headers 'Content-Type' => 'application/json' # NOTE: the outmoded `rocket` syntax MUST be used here
end

SENSOR_SCRIPT = File.expand_path 'pi_receive.py', __dir__

CONFIG = CouchDB.get('/admin/config').to_hash.transform_keys &:to_sym

SENSOR_POLL_INTERVAL = CONFIG[:poll_interval_sensor] # Seconds between sensor readings
CAPACITY = 2743.2 # Maximum distance in mm from the sensor to the tank bottom
IMPERIAL_RATIO = 0.00328084
THRESHOLD_LOW = CONFIG[:threshold_low] / IMPERIAL_RATIO # Level to generate an alert at, in feet

#
# MAIN LOOP
#
loop do
  begin
    # Run the sensor reading script in a sub-shell, capturing the first line of output
    # The expected data format is a 4 digit value, all Integers. Example: 0740
    sensor_reading = (IO.popen SENSOR_SCRIPT, &:readline).to_i

    CouchDB.post '/readings', body: { value: sensor_reading, "_id": Time.now.utc.iso8601 }.to_json

    # Alerts
    tank_level = CAPACITY - sensor_reading
    if tank_level <= THRESHOLD_LOW
      msg = "WARNING! The water tank level is at #{(tank_level * IMPERIAL_RATIO).truncate 2} feet!"
      # call telegram alert bot
      system (File.expand_path 'notify_group.sh', __dir__), msg
      # Log the alert
      CouchDB.post '/logs', body:
        { type: 'alert', category: 'level_low', level: tank_level, "_id": Time.now.utc.iso8601 }.to_json
    end
    if sensor_reading.zero?
      msg = 'WARNING! The tank appears to be overflowing!!!'
      # call telegram alert bot
      system (File.expand_path 'notify_group.sh', __dir__), msg
      # Log the alert
      CouchDB.post '/logs', body:
        { type: 'alert', category: 'level_high', level: tank_level, "_id": Time.now.utc.iso8601 }.to_json
    end
  # Catch *ANY* error occurring while running the master script, logging it and generating an alert
  rescue Exception => e
    CouchDB.post '/logs', body:
      { type: 'alert', category: 'script_error', error: e, "_id": Time.now.utc.iso8601 }.to_json
    abort e
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
