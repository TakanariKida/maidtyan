#coding: utf-8
require 'gmail'
require 'kconv'
require 'date'

require "./MaidMail.rb"
require "./search_today.rb"
require "./Google_calender.rb"
require "./weather.rb"
load "config.rb"

def dots()
  print "・ " # 進捗確認
end

#メールを送信するかしないかのフラグ
mailFlag = 0
fullSchedule = ""
dots()

#gmailにログイン
gmail = Gmail.new(@username,@password)
dots()

#Workフォルダ内の未読を調べる
mail =  gmail.mailbox("#{@mail_label}").emails(:unread).map do |mail|
  dots()
  #件名があるときだけ、
  if mail.subject != nil 
    schedule = Kconv.toutf8(mail.subject)
    schedule = search_today(schedule, mail.date)
    #今日のタスクがある
    if  schedule!= 1
      mailFlag += 1
      #複数のタスクを分ける
      while /\s/ =~ schedule 
         schedule = schedule.sub(/\s/,"・・") 
      end
      while /・・/ =~ schedule 
         schedule = schedule.sub(/・・/,"\n・") 
      end
      fullSchedule += "・" + schedule + "\n"
      
      #mail.mark(:unread) #読み込んだメールを未読に(テスト用)
      next
    end
    mail.mark(:unread) #使わなかったメールを未読に
  end
end
gmail.logout

dots()



if Google_calender() != 0
	fullSchedule += Google_calender()
	mailFlag += 1
end
dots()

maidSerif = MaidMail.new(@address)


#予定のあるときのみ送信
if mailFlag > 0

fullSchedule += "\n" 
fullSchedule +=  weather() # 天気予報


gmail = Gmail.new(@username,@password)
	#メール送信
	gmail.deliver do
		to maidSerif.sendTo
		subject maidSerif.sub
		body maidSerif.text(fullSchedule)
	end
gmail.logout


	#出力結果テスト用
	#maidSerif.showMail (fullSchedule)

end


