module AvailabilityHelper
  require "date_time_extensions.rb"
  # def availabilties_by_slot(availabilities)
  #     availabilities_start_times(availabilities).map do |start_time|
  #         @availabilities.each {|a| a[:start_time]}
  #     end
  # end

  def availabilities_start_times(availabilities)
    start_times =
      availabilities
        .values
        .map { |availability| availability.slots&.keys }
        .compact
        .flatten
        .uniq
        .sort

    start_times.select do |start_time|
      Time.parse(start_time) > Time.now.in_time_zone
    end
  end

  def start_times_in_time_range(availabilities, time_range)
    start_times = availabilities_start_times availabilities
    start_times.select do |start_time|
      start_time.in_time_zone.decimal_hour.in? time_range
    end
  end

  def availabilities_clubs(availabilities)
    @availabilities.map(&:keys).flatten.map { |c_id| Club.find c_id }
  end
end
