# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under CouchDB, and should run persistently.
#
require '../lib/helpers'
require 'httparty'
# require 'bundler'
# Bundler.require :all

# Setup database connection
DB_SERVER = 'http://127.0.0.1:5984'
DB_NAME = 'readings'

# $db_server = CouchRest.new DB_SERVER
# $db = $db_server.database DB_NAME

class CouchDB
  include HTTParty
  base_uri "#{DB_SERVER}/#{DB_NAME}"
  format :json
  headers 'Content-Type' => 'application/json' # note: MUST use old style hash syntax here
end

# Sensor reading (distance in millimeters)
# class DistanceReading < CouchRest::Model::Base
#   use_database DB_NAME
#   property :value, Float
#   timestamps!
# end

# todo: store these values in DB config
SENSOR_POLL_INTERVAL = ENV['SENSOR_POLL_INTERVAL'] || 600 # seconds between sensor readings
SENSOR_SCRIPT        = '/usr/local/ranch-water-tank-sensor-project/scripts/sensorScript.py'

loop do
  # Run the sensor read script in a subshell, capturing the first line of output
  reading = IO.popen("python #{SENSOR_SCRIPT}") {|io| io.readline}

  # todo: handle errors and bad output

  # Save the measurement to the database, converting it to a Float in the process
  # DistanceReading.create! value: reading.to_f
  CouchDB.post('', body: {value: reading.to_f, time: Time.now}.to_json)

  # todo: generate alert if water level val within specified threshold range

  sleep SENSOR_POLL_INTERVAL.to_f
end
