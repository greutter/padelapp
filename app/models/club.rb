# == Schema Information
#
# Table name: clubs
#
#  id                   :bigint           not null, primary key
#  address              :string
#  city                 :string
#  comuna               :string
#  google_maps_link     :string
#  latitude             :integer
#  longitude            :integer
#  name                 :string
#  phone                :string
#  region               :string
#  third_party_software :string
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  third_party_id       :integer
#

#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Club < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :courts
  has_many :schedules

  def opens_at(date)
    if self.schedules.custom_default_for(date)
      custom_default = self.schedules.custom_default_for(date)
      p custom_default
      date.beginning_of_day.change(
        { hour: custom_default.opens_at.hour, min: custom_default.opens_at.min }
      )
    else
      date.beginning_of_day.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  def closes_at(date)
    if false #self.schedules.custom_default_for(date)
      default = self.schedules.custom_default_for(date)
      date.beginning_of_day.in_time_zone.change(
        { hour: default.closes_at.hour, min: default.closes_at.min }
      )
    else
      date.beginning_of_day.in_time_zone.change(
        hour: Schedule::DEFAULTS[:closes_at]
      )
    end
  end

  def third_party_availability(date:, durations: [90])
    if self.third_party_software.nil? 
      not_third_party_availability(date, durations)
    else
      EasycanchaBot.availability(self.third_party_id, date, duration.first)
    end
  end

  def availability(date, durations)
    available_slots = {}
    as = []
    durations.each do |duration|
      (opens_at(date).to_i..(closes_at(date) - duration.minutes).to_i).step(30.minutes).each do |time|
        starts_at = Time.at time
        # break if starts_at <= DateTime.now.in_time_zone - 15.minutes    
        self.courts.each do |court|
          ends_at = starts_at + duration.minutes
          if court.is_slot_available?(starts_at: starts_at, ends_at: ends_at)  
            puts "{starts_at: #{starts_at}, ends_at: #{ends_at}, court_id: #{court.id}}"
            as << { starts_at: starts_at, ends_at: ends_at, court_id: court.id }
            break
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
