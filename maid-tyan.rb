#coding: utf-8
require 'gmail'
require 'kconv'
require 'date'

require "./MaidMail.rb"
require "./search_today.rb"
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
mail =  gmail.mailbox('Work/maid-tyan').emails(:unread).map do |mail|
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

dots()
#予定のあるときのみ送信
if mailFlag > 0
	maidSerif = MaidMail.new(@address)

dots()

begin
	#メール送信
	gmail.deliver do
		to maidSerif.sendTo
		subject maidSerif.sub
		body maidSerif.text(fullSchedule)
	end
end

	#出力結果テスト用
	#maidSerif.showMail (fullSchedule)


end
