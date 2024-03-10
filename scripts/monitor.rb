#!/usr/bin/env ruby
#
# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is meant to be daemonized as a service via systemd (e.g. /etc/systemd/system/monitor.service)
#
# Copyright (C) 2024 Stephen C. Benner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author: Stephen Benner
# https://github.com/SteveBenner
#
require 'httparty'
require 'time'

# Database connection (SLEEP IS VITAL, as CouchDB ISN'T IMMEDIATELY UP upon login, and the script fails without it)
sleep 10
DB_SERVER = 'http://127.0.0.1:5984'
class CouchDB
  include HTTParty
  base_uri DB_SERVER
  format :json
  headers 'Content-Type' => 'application/json' # NOTE: the outmoded `rocket` syntax MUST be used here
end

SENSOR_SCRIPT = File.expand_path 'pi_receive.py', __dir__
CAPACITY = 2743.2 # Maximum distance in mm from the sensor to the tank bottom
IMPERIAL_RATIO = 0.00328084

def send_to_telegram_bot(msg)
  system (File.expand_path 'notify_group.sh', __dir__), msg
end

def log_to_couchdb(body)
  body['_id'] = Time.now.utc.iso8601
  body['type'] = 'alert'
  CouchDB.post '/logs', body: body.to_json
end

#
# MAIN LOOP
#
last_alert = Time.now
loop do
  begin
    # Read configuration values from the database
    CONFIG = CouchDB.get('/admin/config').to_hash.transform_keys &:to_sym
    SENSOR_POLL_INTERVAL = CONFIG[:poll_interval_sensor] # Seconds between sensor readings
    THRESHOLD_LOW = CONFIG[:threshold_low] / IMPERIAL_RATIO # Level to generate an alert at, in feet

    # Run the sensor reading script in a sub-shell, capturing the first line of output
    # The expected data format is a 4 digit value, all Integers. Example: 0740
    sensor_reading = (IO.popen SENSOR_SCRIPT, &:readline).to_i

    CouchDB.post '/readings', body: { '_id': Time.now.utc.iso8601, value: sensor_reading }.to_json

    # Alerts (configurable via database)
    tank_level = CAPACITY - sensor_reading
    if Time.now - last_alert > CONFIG[:poll_interval_alerts] && (tank_level <= THRESHOLD_LOW || sensor_reading.zero?)
      last_alert = Time.now # Reset counter to ensure alert throttling works
      msg = if sensor_reading.zero?
              alert_category = 'level_high'
              'WARNING! The tank appears to be overflowing!!!'
            else
              alert_category = 'level_low'
              "WARNING! The water tank level is at #{(tank_level * IMPERIAL_RATIO).truncate 2} feet!"
            end
      send_to_telegram_bot msg
      # Log the alert
      log_to_couchdb category: alert_category, level: tank_level.truncate
    end
  # Catch *ANY* error occurring while running the master script, logging it and generating an alert
  rescue Exception => e
    log_to_couchdb category: 'script_error', error: e
    send_to_telegram_bot 'ALERT! The script has experienced a technical problem. Contact tech support immediately!'
    abort e
  end

  sleep SENSOR_POLL_INTERVAL.to_f
end
