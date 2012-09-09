# coding: utf-8

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
			"ζﾉ≧▽≦)ﾉ メイドちゃんです♪"
			]
		return array[rand(array.length)]
	end
	


	def text(fullSchedule)
		day = Time.now
			
# ＊＊＊＊＊＊＊メール本文＊＊＊＊＊＊＊＊＊
maid_tyan_message = <<-EOS
ご主人様 おはようございます！
#{status}

今日(#{day.strftime("%m月%d日")})のご予定をお知らせしますね。
#{fullSchedule}
それでは 今日も元気に頑張ってください♪
EOS
# ＊＊＊＊＊＊＊メール本文 ＊＊＊＊＊＊＊＊

		@sendText = maid_tyan_message
	
		return @sendText
	end

	
	def showMail(fullSchedule)
		text(fullSchedule)
		print @sendTo + "\n"
		print @sendSub + "\n"
		print @sendText + "\n"
	end
	
end