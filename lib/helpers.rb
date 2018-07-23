# @return [Hash] Key/value pairs of data enumerated within a .cfg file
def parse_cfg_file(filename)
  data = File.read filename
  Hash[data.scan /(\S+)*=([^\n]+)/]
end