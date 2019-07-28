#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under cron
#
# DEPENDENCIES:
# - HTTParty
# todo: refactor sensor script to use arguments for multiple operation modes, i.e. run ONCE, or run continuously?

# require '../lib/helpers'
require 'httparty'
require 'time'
# require 'bundler'
# Bundler.require :all
# todo: use couchrest_model

# Database connection
DB_SERVER  = 'http://127.0.0.1:5984'
$DB        = 'readings'

# $db_server = CouchRest.new DB_SERVER
# $db = $db_server.database DB_NAME
class CouchDB
  include HTTParty
  base_uri DB_SERVER + '/'
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
SENSOR_POLL_INTERVAL = 30 # Seconds between sensor readings
SENSOR_SCRIPT        = '/home/pi/water-tank-sensor-control/scripts/receive.py'

# Check the timestamp of last record successfully saved to local DB, to establish downtime, if any
LAST_RECORD_TIMESTAMP = 0
  # check for downtime, logging any detected
  # todo: calculate downtime based on discrepancy between last record successfully

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
  CouchDB.post $DB, body: {value: sensor_reading.to_i, timestamp: Time.now.utc.iso8601}.to_json

  # todo: generate notice and exit if sensor reading script stops sending data

  # todo: generate alert if water level val within specified threshold range
  #
  # todo: ERROR MANAGEMENT
  rescue Exception # this will catch *ANY* error
    # todo: ERROR LOGGING CODE GOES HERE
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
