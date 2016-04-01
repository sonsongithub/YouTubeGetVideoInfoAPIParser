#!/usr/bin/env ruby

require "cgi"

buf = STDIN.gets
queries = CGI.parse(buf)

buf = queries
buf.each{|k,v|
  throw if v.length != 1
  queries[k] = v[0]
  if v[0] =~ /^[\d\-]+$/
    puts v[0]
  end
}

"keywords"
"watermark"
"url_encoded_fmt_stream_map"

p queries
