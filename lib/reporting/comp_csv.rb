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
    return "NaN" if value.nil? or value.length == 0
    value.to_s! unless value.is_a? String
    value.gsub(',','').to_i
  end

  def get_report
    report = ""
    report += "Position, Game name, MAU rank, DAU rank, MAU rank (lw), DAU rank (lw)\n"

    @games.each do |game|
      game.chomp!

      dau = normalise @db.get( "watchlist.#{game}.#{@last_run}.dau" )
      mau = normalise @db.get( "watchlist.#{game}.#{@last_run}.mau" )

      dau_last = normalise @db.get( "watchlist.#{game}.#{@last_week}.dau" )
      mau_last = normalise @db.get( "watchlist.#{game}.#{@last_week}.mau" )

     report += "0, #{game}, #{mau}, #{dau}, #{mau_last}, #{dau_last}\n"
    end
    report
  end

end
