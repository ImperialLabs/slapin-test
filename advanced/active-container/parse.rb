#!/usr/bin/env ruby

require 'pp'
require 'json'

json = JSON.parse(ARGV[0])

puts json['type']
puts json['user']
puts json['text']
