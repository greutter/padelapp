class ActiveSupport::TimeWithZone

  def decimal_hour
    (self.hour + self.min / 60.0)
  end

end
