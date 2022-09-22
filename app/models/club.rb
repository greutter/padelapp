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
    if self.schedules.custom_default_for_day(date.day)
      default = self.schedules.custom_default_for_day(date.day)
      date.to_datetime.change({hour: default.opens_at.hour,
                               minute: default.closes_at.minute}).to_datetime
    else
      date.to_datetime.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  def closes_at date
    date.to_datetime.change(hour: Schedule::DEFAULTS[:closes_at])
  end

  def availabel_slots(date: , duration: )
    courts.first.availabel_slots(date: date, duration: duration)
  end

end