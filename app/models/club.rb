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
    if self.schedules.default(date.day).any?
      default = self.schedules.default(date.day).first
      date.to_datetime.change({hour: default.opens_at, minute: default.closes_at})
    else
      date.to_datetime.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  def closes_at date
    date.to_datetime.change(hour: Schedule::DEFAULTS[:closes_at])
  end

end
