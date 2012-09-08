# coding: utf-8

#天気用
require "weather_hacker"

#カレンダー用
require "rubygems"
require "gcalapi"

#パスワードなどのコンフィグファイル
load "config.rb"

#メイドちゃんがメール本文を作成するクラス
class MaidMail

	def initialize( address = @address )
		@sendTo = address
		@sendSub = "メイドちゃんより"
		@sendText = ""
	end
	
	def sendTo
		return @sendTo
	end
	
	def sub
		return @sendSub
	end
	
	def status # メイドちゃんの表情を日替わりにしてみる
		array = [
			"メイドちゃんです.ヾ(＾▽＾*ζ",
			"ζ＞∇＜)ﾉ メイドちゃんです.",
			"メイドちゃんですよ♪ ｖ(・ω・",
			"ζﾉ≧▽≦)ﾉ メイドちゃです♪"
			]
		return array[rand(array.length)]
	end
	
	def weather # 天気予報士メイドちゃん
		forecast = WeatherHacker.new(@zipcode)
		weatherMessage = "今日の天気は、#{forecast.today['weather']\n}"
		if /^雨$/ =~ forecast.today['weather']#”雨”の予報のとき
			weatherMessage += "雨に濡れて風邪などひかれませんようお気を付け下さい。\n" 
		elsif /雨/ =~ forecast.today['weather']# ”雨のち曇り”とか”雨時々晴”とかの予報のとき
			weatherMessage += "今日は折り畳み傘がいるかもです。\n" 
		end
		return weatherMessage
	end
	
	def calender # Googleカレンダーの予定をお知らせ
		#http://d.hatena.ne.jp/senggonghaza/20110406/1302101569 を参考
		cal_sc =""
		cal_sc_count = 0
		feed = "http://www.google.com/calendar/feeds/#{@username}/private/full?alt=json"
	
		# Googleカレンダーに接続
		srv = GoogleCalendar::Service.new(@username,@password)
		cal = GoogleCalendar::Calendar::new(srv, feed)
		events = cal.events
		
		events.each do |event|
			if event.st.to_s.slice(0..9) == Date.today.to_s.slice(0..9)
				cal_sc += "・" + event.title
				cal_sc_count += 1
				if event.st.to_s.slice(11..18) != "00:00:00"
					cal_sc +=  event.st.to_s.slice(11..18) + " ～ \n"
				end
				if event.where != ""
					cal_sc += "＠ " + event.where + "\n"
				end
			end
		end
		
		# カレンダーに予定があるときのみ表示
		if cal_sc_count > 0
			cal_sc = "\nカレンダーには、このような予定がありました。\n" + cal_sc
		end
	end
	
	def text(fullSchedule)
		day = Time.now
			
# ＊＊＊＊＊＊＊メール本文＊＊＊＊＊＊＊＊＊
maid_tyan_messageFirst = <<-EOS
ご主人様 おはようございます！
#{status}
#{weather}
今日(#{day.strftime("%m月%d日")})のご予定をお知らせしますね。
#{fullSchedule}
#{calender}

それでは 今日も元気に頑張ってください♪
EOS
# ＊＊＊＊＊＊＊メール本文 ＊＊＊＊＊＊＊＊

		@sendText += maid_tyan_messageFirst + maid_tyan_messageLast
	
		return @sendText
	end

	
	def showMail(fullSchedule)
		text(fullSchedule)
		print @sendTo + "\n"
		print @sendSub + "\n"
		print @sendText + "\n"
	end
	
end