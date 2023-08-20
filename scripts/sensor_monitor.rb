#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under cron (/etc/crontab)
#
require 'httparty'
require 'time'
# require 'bundler'
# Bundler.require :all

# Database connection
DB_SERVER   = 'http://127.0.0.1:5984'

class CouchDB
  include HTTParty
  base_uri DB_SERVER
  format :json
  headers 'Content-Type' => 'application/json' # NOTE: the outmoded `rocket` syntax MUST be used here
end

# todo: store these values in DB config
SENSOR_SCRIPT        = '/home/pi/scripts/pi_receive.py'



SENSOR_POLL_INTERVAL = 300 # Seconds between sensor readings

# Check the timestamp of last record successfully saved to local DB, to establish downtime, if any
# todo: calculate downtime based on discrepancy between last record successfully, log anything significant

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

  # todo: check for cases of '0' value from sensor read script
  # todo: generate notice and exit if sensor reading script stops sending data

  # todo: generate alert if water level val within specified threshold range
  #
  # todo: ERROR MANAGEMENT
  rescue Exception # this will catch *ANY* error
    # todo: ERROR LOGGING CODE GOES HERE
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
