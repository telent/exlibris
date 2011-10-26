
Time::DATE_FORMATS[:recent] = lambda{|time| 
  now=Time.now
  today=now.beginning_of_day.to_i
  date=time.beginning_of_day.to_i
  warn [(time-now).abs< 4*30*86400]
  date_part=
  if time<now-180*86400 || time>now+180*86400 then
    time.strftime("%a, %d %b %Y")
  elsif (date==today) then
    "Today"
  elsif ((date==today+86400) and time<now+43200+86400) then
    "Tomorrow"
  elsif time<now+5*86400 then
    time.strftime("%A")
  else
    time.strftime("%a, %d %B")
  end

  if date_part=="Today" then date_part="" end
  time_part=if time.sec.zero? then 
              time.strftime("%l:%M%P").strip
            else 
              time.strftime("%l:%M:%S%P").strip
            end
  [date_part,time_part].join " "
}
