# == Schema Information
#
# Table name: clubs
#
#  id               :bigint           not null, primary key
#  address          :string
#  google_maps_link :string
#  name             :string
#  phone            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Club < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :courts
  has_many :schedules

  def opens_at date
    #TODO: add specific defaults
    if self.schedules.custom_default_for_day(date.day)
      default = self.schedules.custom_default_for_day(date.day)
      date.beginning_of_day.in_time_zone.change({hour: default.opens_at.hour,
                               minute: default.opens_at.minute})
    else
      date.beginning_of_day.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  def closes_at date
    if self.schedules.custom_default_for_day(date.day)
      default = self.schedules.custom_default_for_day(date.day)
      date.beginning_of_day.in_time_zone.change({hour: default.closes_at.hour,
                               minute: default.closes_at.minute})
    else
      date.beginning_of_day.in_time_zone.change(hour: Schedule::DEFAULTS[:closes_at])
    end
  end

  def availability(date: , durations: [90])
    available_slots = {}
    durations.each do |duration|
      starts_at = opens_at(date)
      ends_at = starts_at + duration.minutes
      as = []
      while ends_at < closes_at(date)
        self.courts.each do |court|
          if court.is_slot_available?(starts_at: starts_at, ends_at: ends_at) and starts_at >= DateTime.now.in_time_zone - 15.minutes
            puts "{starts_at: #{starts_at}, ends_at: #{ends_at}, court_id: #{court.id}}"
            as << {starts_at: starts_at, ends_at: ends_at, court_id: court.id}
            starts_at += 30.minutes
            ends_at = starts_at + duration.minutes
            break
          else
            starts_at += 30.minutes
            ends_at = starts_at + duration.minutes
            next
          end
        end
      end
    available_slots[duration] = as
    end
    return available_slots
  end

  # def get_availabel_slots(date: , durations: [90])
  #   courts.first.get_availabel_slots(date: date, durations: durations)
  # end


end
