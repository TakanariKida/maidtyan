# coding: utf-8

#カレンダー用
require "rubygems"
require "gcalapi"

#パスワードなどのコンフィグファイル
load "config.rb"

	def Google_calender # Googleカレンダーの予定をお知らせ
		#http://d.hatena.ne.jp/senggonghaza/20110406/1302101569 を参考
		cal_sc =""
		cal_sc_count = 0
		feed = "http://www.google.com/calendar/feeds/#{@username}/private/full?alt=json"

		# Googleカレンダーに接続
		srv = GoogleCalendar::Service.new( @username, @password )
		cal = GoogleCalendar::Calendar::new(srv, feed)
		allevents = cal.events


		allevents.each do |event|
			if event.st.to_s.slice(0..9) == Date.today.to_s.slice(0..9)
				cal_sc += "・" + event.title + "\n"
				cal_sc_count += 1
				if event.st.to_s.slice(11..18) != "00:00:00"
					timetmp = event.st.to_s.slice(11..12)
					timetmp = timetmp.to_i
					timetmp += 9
					cal_sc +=  " " + timetmp.to_s + event.st.to_s.slice(13..15) + " ～ \n" #
				end
				if event.where != ""
					cal_sc += "   ＠ " + event.where + "\n"
				end
			end
		end

		# カレンダーに予定があるときのみ表示
		if cal_sc_count > 0
			cal_sc = "\nカレンダーには、このような予定がありました。\n" + cal_sc
			return cal_sc
		end
		return 0
	end
