# CONTROL SCRIPT FOR WATER TANK MONITORING SYSTEM
#
# This script is daemonized under CouchDB, and should run persistently.
#
require '../lib/helpers'
require 'couchrest_model'

DB_NAME = 'readings'

$db_server = CouchRest.new 'http://127.0.0.1:5984'
$db = $db_server.database DB_NAME

class Reading < CouchRest::Model::Base
  property :value, String
  property :time, String
  timestamps!
end

# todo: call sensor read script intermittently

# todo: save data recordings to DB

# todo: generate alert if water level val within specified threshold range

