# coding: utf-8

#天気用
require "weather_hacker"

#パスワードなどのコンフィグファイル
load "config.rb"

	def weather # 天気予報士メイドちゃん
		zipcode = @zipcode
		forecast = WeatherHacker.new(zipcode)
		if forecast.today
		weatherMessage = "今日の天気は、#{forecast.today['weather']}です\n"
		if /^雨$/ =~ forecast.today['weather']#”雨”の予報のとき
			weatherMessage += "濡れて風邪などひかれませんようお気を付け下さい。\n" 
		elsif /雨/ =~ forecast.today['weather']# ”雨のち曇り”とか”雨時々晴”とかの予報のとき
			weatherMessage += "折り畳み傘がいるかもです。\n" 
		end
		end
		return weatherMessage
	end