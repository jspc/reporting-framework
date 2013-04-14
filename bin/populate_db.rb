#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'uri'
require 'colorize'
require 'redis'
require 'time'

db    = Redis.new
games = open( "./games.txt", 'r' ).readlines()
date  = Time.now.strftime "%Y-%m-%d %H:%M"

db.lpush "watchlist.run_times", date

games.each do |game|
  game.chomp!
  begin
    uri = "http://www.appdata.com/search?utf8=%E2%9C%93&app_type=facebook_app&q=#{URI.escape game.rstrip}&commit=true"
    game_site = Nokogiri::HTML(open( uri ) )

    game_hash = Hash.new
    game_site.css( 'div.span12' ).each do |span|
      span.css( 'td' ).each do |td|
        game_hash[ :"#{td.css('span.font_size_16_bold').text.to_sym}" ] = td.css('span.font_size_24_bold').text
      end
    end

    db.set "watchlist.#{game}.#{date}.mau", "#{ game_hash[:"MAU Rank"] ? game_hash[:"MAU Rank"] : nil }"
    db.set "watchlist.#{game}.#{date}.dau", "#{ game_hash[:"DAU Rank"] ? game_hash[:"DAU Rank"] : nil }"

  rescue Exception=>e
    puts "We had an issue with #{game.rstrip}: #{e}".red
  end
end

db.save
