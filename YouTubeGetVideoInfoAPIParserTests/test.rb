#!/usr/bin/env ruby

require "cgi"
require "uri"
require 'json'

buf = STDIN.gets
queries = CGI.parse(buf)

buf = queries
buf.each{|k,v|
  throw if v.length != 1
  queries[k] = v[0]
}

output = {}
puts queries["url_encoded_fmt_stream_map"]
puts queries["url_encoded_fmt_stream_map"].split(",")

fmt = queries["url_encoded_fmt_stream_map"].split(",").map {|item|
  buf = CGI.parse(item)
  buf.each{|k,v|
    throw if v.length != 1
    buf[k] = v[0]
  }
  buf
}

fmt = fmt.sort{|a,b| b["itag"].to_i <=> a["itag"].to_i }

output["url_encoded_fmt_stream_map"] = fmt

output["title"] = queries["title"]
output["length_seconds"] = queries["length_seconds"]

puts output.to_json
