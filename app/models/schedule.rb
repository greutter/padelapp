# == Schema Information
#
# Table name: schedules
#
#  id          :bigint           not null, primary key
#  closes_at   :datetime
#  day_of_week :integer
#  opens_at    :datetime
#  tipo        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club_id     :integer
#
class Schedule < ApplicationRecord
  belongs_to :club, required: true
  validates :opens_at, presence: true
  # validates :closes_at, presence: true
  validates :day_of_week, uniqueness: {scope: :club_id}

  DEFAULTS = { opens_at: 7, closes_at: 23 }

  def self.custom_default_for(date)
    self.find_by(tipo: "default", day_of_week: date.wday)
  end
end
