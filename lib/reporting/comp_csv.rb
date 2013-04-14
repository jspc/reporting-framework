#!/usr/bin/env ruby
#
# Get the last run time, get a week prior to that
# and start getting data


class Comp_CSV
  attr_accessor :name, :version

  def initialize db, games
    @name    = "Competitors Watchlist CSV"
    @version = "0.0.1"
    @db    = db
    @games = games

    @last_run  = db.lrange( "watchlist.run_times", 0, 0 ).last()
    @last_week = (@last_run.to_time - 1.week).strftime( "%Y-%m-%d %H:%M" )
  end

  def normalise value
    return 0 if value.nil? or value.length == 0
    value.to_s! unless value.is_a? String
    value.gsub(',','').to_i
  end

  def build_hashes
    report = []

    @games.each do |game|
      game.chomp!

      report << {
        :name     => game,
        :dau      => normalise( @db.get( "watchlist.#{game}.#{@last_run}.dau" ) ),
        :mau      => normalise( @db.get( "watchlist.#{game}.#{@last_run}.mau" ) ),
        :dau_last => normalise( @db.get( "watchlist.#{game}.#{@last_week}.dau" ) ),
        :mau_last => normalise( @db.get( "watchlist.#{game}.#{@last_week}.mau" ) ),
      }
    end
    report
  end

  def get_report
    ranking = 1
    report = "Ranking, Game, DAU, MAU, DAU (lw), MAU (lw)\n"

    report_array = build_hashes
    report_array.sort_by { |x| x[:dau] }.each do |report_hash|
      if report_hash[:dau] > 0
        report += "#{ranking},"
        ranking+=1
      else
        report+= "n/a,"
      end
      report += "#{report_hash[:name]}, #{report_hash[:dau]}, #{report_hash[:mau]}, #{report_hash[:dau_last]}, #{report_hash[:mau_last]}\n"
    end
    report
  end
end
