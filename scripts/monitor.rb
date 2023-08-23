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

#
# MAIN LOOP
#
loop do
  begin
  # Run the sensor reading script in a sub-shell, capturing the first line of output
  # The expected data format is a 4 digit value, all Integers. Example: 0740
  sensor_reading = IO.popen SENSOR_SCRIPT, &:readline

  # Save the measurement to the database
  CouchDB.post '/readings', body: { value: sensor_reading.to_i, "_id": Time.now.utc.iso8601 }.to_json

  # todo: generate alert if water level val within specified threshold range
  # todo: generate alert if reading is 0 (indicating overflow)

  # Catch *ANY* error occurring while running the master script, logging it and generating an alert
  rescue Exception
    # todo: ERROR LOGGING CODE GOES HERE
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
