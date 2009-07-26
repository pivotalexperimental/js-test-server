require "rubygems"
require "uri"
require "curb"

Curl::Easy.http_post(
  "http://localhost:8080/remote_control/broadcasts",
  "javascript=#{URI.encode("alert('hey you')")}"
)