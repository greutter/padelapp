class Time
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def change_hour_minutes(time_string)
    t = time_string.split(":")
    hour = t[0]
    minutes = t[1]
    self.change(hour: hour, min: minutes)
  end
end
