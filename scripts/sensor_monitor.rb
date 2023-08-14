#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under cron (/etc/crontab)
#
# DEPENDENCIES:
# - HTTParty
#
# todo: refactor sensor script to use arguments for multiple operation modes, i.e. run ONCE, or run continuously?
require 'httparty'
require 'time'
# require 'bundler'
# Bundler.require :all
# todo: use couchrest_model

# Database connection
DB_SERVER  = 'http://127.0.0.1:5984'
DB_NAME    = 'readings'
DB_URL     = '/' + DB_NAME # HTTParty strips any forward slashes from `base_url` so we must prepend one for basic POST

# $db_server = CouchRest.new DB_SERVER
# $db = $db_server.database DB_NAME
class CouchDB
  include HTTParty
  base_uri DB_SERVER
  format :json
  headers 'Content-Type' => 'application/json' # NOTE: the outmoded `rocket` syntax MUST be used here
end

# todo: create data model code
# Sensor reading (distance in millimeters)
# class DistanceReading < CouchRest::Model::Base
#   use_database DB_NAME
#   property :value, Float
#   timestamps!
# end

# todo: store these values in DB config
SENSOR_POLL_INTERVAL = 600 # Seconds between sensor readings
SENSOR_SCRIPT        = '/home/pi/water-tank-sensor-control/scripts/receive.py'

# Check the timestamp of last record successfully saved to local DB, to establish downtime, if any
# todo: calculate downtime based on discrepancy between last record successfully, log anything significant

#
# MAIN LOOP
#
loop do
  begin
  # Run the sensor reading script in a sub-shell, capturing the first line of output
  sensor_reading = IO.popen SENSOR_SCRIPT, &:readline

  # Save the measurement to the database
  # DistanceReading.create! value: reading.to_i
  # todo: test
  CouchDB.post DB_URL, body: {value: sensor_reading.to_i, "_id": Time.now.utc.iso8601}.to_json

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
