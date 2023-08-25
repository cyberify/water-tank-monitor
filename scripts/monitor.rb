#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under cron (/etc/crontab)
#
require 'httparty'
require 'time'

# Database connection
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
EMPTY = 2286 # Maximum distance in mm from the sensor to the tank bottom

#
# MAIN LOOP
#
loop do
  begin
    # Run the sensor reading script ingit p a sub-shell, capturing the first line of output
    # The expected data format is a 4 digit value, all Integers. Example: 0740
    sensor_reading = (IO.popen SENSOR_SCRIPT, &:readline).to_i

    CouchDB.post '/readings', body: { value: sensor_reading.to_i, "_id": Time.now.utc.iso8601 }.to_json

    # Alerts
    if sensor_reading >= CONFIG[:threshold_low]
      tank_level = EMPTY - sensor_reading
      msg = "WARNING! The tank level is below #{tank_level}mm!"
      # call telegram alert bot
      exec (File.expand_path 'notify_group.sh', __dir__), msg
      # Log the alert
      CouchDB.post '/logs', body:
        { type: 'alert', category: 'level_low', level: tank_level, "_id": Time.now.utc.iso8601 }.to_json
    end
    if sensor_reading == CONFIG[:threshold_high]
      tank_level = EMPTY - sensor_reading
      msg = 'WARNING! The tank is overflowing!'
      # call telegram alert bot
      exec (File.expand_path 'notify_group.sh', __dir__), msg
      # Log the alert
      CouchDB.post '/logs', body:
        { type: 'alert', category: 'level_high', level: tank_level, "_id": Time.now.utc.iso8601 }.to_json
    end
  # Catch *ANY* error occurring while running the master script, logging it and generating an alert
  rescue Exception => e
    CouchDB.post '/logs', body:
      { type: 'alert', category: 'script_error', error: e, "id": Time.now.utc.iso8601 }.to_json
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
