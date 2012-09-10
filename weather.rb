# coding: utf-8

#天気用
require "weather_hacker"

#パスワードなどのコンフィグファイル
load "config.rb"

	def weather # 天気予報士メイドちゃん
		zipcode = @zipcode
		forecast = WeatherHacker.new(zipcode)
		weatherMessage =""
begin
		todayweather = forecast.today['weather']
		if todayweather != ""
			weatherMessage = "今日の天気は、#{todayweather}です\n"
			if /^雨$/ =~ todayweather #”雨”の予報のとき
				weatherMessage += "濡れて風邪などひかれませんようお気を付け下さい。\n" 
			elsif /雨/ =~ todayweather # ”雨のち曇り”とか”雨時々晴”とかの予報のとき
				weatherMessage += "折り畳み傘がいるかもです。\n" 
			end
		end
rescue
end
		return weatherMessage
	end
