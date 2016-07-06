#!/usr/bin/env ruby
#
# Utility for interfacing with 'Ubiquiti airOS' systems
#
# @author Stephen Benner
# https://github.com/SteveBenner
#
require 'optparse'
require 'yaml'

# Default options
opts = {}
# Command line interface
optparser = OptionParser.new do |cli|
  cli.version = '0.0.1'
  cli.summary_width  = 24
  cli.summary_indent = ' ' * 2
  cli.banner = "Utility for interfacing with 'Ubiquiti airOS' systems" + $/ +
    'Usage: ${0} [options]'
  cli.on_tail('-h', '--help', '--usage', 'Display this message.') { puts cli; exit }
  cli.on_tail('--version', 'Display script version.') { puts cli.version; exit }
end.parse!

# @return [Hash] Key/value pairs enumerated within a .cfg file
def parse_cfg_file(filename)
  data = File.read filename
  Hash[data.scan /(\S+)*=([^\n]+)/]
end

