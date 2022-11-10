class Time
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end
end
