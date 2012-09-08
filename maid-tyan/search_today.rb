def search_today(schedule, maildate) # 今日の分のメールがあるか探す
 day = Time.now
 wdays = ["日", "月", "火", "水", "木", "金", "土"]
    day_m = day.strftime("%m")
    day_d = day.strftime("%d")

case schedule
  when /^#{day_m}#{day_d}\s*/
    schedule = $'
    return schedule
  when /^#{day_m}\/#{day_d}\s*/
    schedule = $'
    return schedule
  when /^#{day_d}\s*/
    schedule = $'
    return schedule
  when /^#{day_d.slice(1..1)}\s*/
    schedule = $'
    return schedule
  when /^#{day_m.slice(1..1)}#{day_d}\s*/
    schedule = $'
    return schedule
  when /^#{day_m.slice(1..1)}\/#{day_d}\s*/
    schedule = $'
    return schedule
  when /^#{wdays[day.wday]}(曜|曜日|)\s*/
    schedule = $'
    return schedule
  when /^(明日|あす|あした)\s*/
    schedule = $'
    day_minus = Date.today - 1
    if maildate.to_s.slice(0..9) == day_minus.to_s.slice(0..9)
      return schedule
    end
    return 1
  when /^(明後日|あさって)\s*/
    schedule = $'
    day_minus = Date.today - 2
    if maildate.to_s.slice(0..9) == day_minus.to_s.slice(0..9)
      return schedule
    end
    return 1
  else
    return 1
end

end # for search_today