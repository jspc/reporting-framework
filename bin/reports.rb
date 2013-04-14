#!/usr/bin/env ruby
#
# Run the specified reports

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'redis'
require 'active_support/core_ext'
require 'reporting/comp_csv'
require 'optparse'

db     = Redis.new
report = "comp_csv"
games  = File.join(File.dirname(__FILE__), '..', 'etc', 'games.txt')

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-g", "--games [FILE]", "Games File")         { |g| games  = g }
  opts.on("-r", "--report [REPORT]", "Report to run")   { |r| report = r }
end.parse!

raise "Error: File #{games} does not exist" unless File.file? games
read_games = open( games, 'r').readlines()



puts Comp_CSV.new( db, read_games ).get_report()
