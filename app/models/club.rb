# == Schema Information
#
# Table name: clubs
#
#  id               :bigint           not null, primary key
#  address          :string
#  google_maps_link :string
#  name             :string
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
                               minute: default.closes_at.minute})
    else
      date.beginning_of_day.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  #TODO: add custom defaults
  def closes_at date
    date.beginning_of_day.in_time_zone.change(hour: Schedule::DEFAULTS[:closes_at])
  end

  def get_availabel_slots(date: , durations: [90])
    courts.first.get_availabel_slots(date: date, durations: durations)
  end

end
