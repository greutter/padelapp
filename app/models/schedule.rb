# == Schema Information
#
# Table name: schedules
#
#  id          :bigint           not null, primary key
#  closes_at   :datetime
#  day_of_week :integer
#  opens_at    :datetime
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club_id     :integer
#
class Schedule < ApplicationRecord
  belongs_to :club, required: true
  validates :opens_at, presence: true
  # validates :closes_at, presence: true

  DEFAULTS = { opens_at: 7, closes_at: 23}

  scope :default, -> (day_of_week) { where("day_of_week = ?", 1)}
end
