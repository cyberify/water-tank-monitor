#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under CouchDB, and should run persistently.
#
# DEPENDENCIES:
# - HTTParty
# todo: refactor sensor script to use arguments for multiple operation modes, i.e. run ONCE, or run continuously?

# require '../lib/helpers'
require 'httparty'
# require 'bundler'
# Bundler.require :all

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
SENSOR_POLL_INTERVAL = ENV['SENSOR_POLL_INTERVAL'] || 600 # Seconds between sensor readings
SENSOR_SCRIPT        = '/home/pi/water-tank-sensor-control/scripts/getReading.py'

#
# Hooks & auxiliary operations
#

# Check the timestamp of last record successfully saved to local DB, to establish downtime, if any
LAST_RECORD_TIMESTAMP = 0
  # check for downtime, logging any detected
  # todo: calculate downtime based on discrepancy between last record successfully

# Operations to carry out before sensor readings are processed
def pre_hook
end

#
# MAIN LOOP
#
# todo: refactor to RUN ONCE mode
loop do
  begin
  pre_hook

  # Run the sensor reading script in a sub-shell, capturing the first line of output
  # todo: test
  sensor_reading = IO.popen("python #{SENSOR_SCRIPT}") { |io| io.readline }

  # Save the measurement to the database, converting it to a Float in the process
  # DistanceReading.create! value: reading.to_f # todo: create data model code
  CouchDB.post $DB, body: {value: sensor_reading.to_f, time: Time.now}.to_json

  # todo: generate alert if water level val within specified threshold range
  # todo: FINISH ERROR MANAGEMENT
  rescue Exception # this will catch *ANY* error; this granularity could possibly be refined...
    # todo: ERROR LOGGING CODE GOES HERE
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end

# todo: write before-exit hook code here
