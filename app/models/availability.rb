# == Schema Information
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  date       :string
#  duration   :integer
#  slots      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  club_id    :string
#
class Availability < ApplicationRecord
  belongs_to :club
  validates :slots, presence: true
  validates :duration, presence: true

  scope :updated_within,
        ->(time = 10.minutes) { where("updated_at > ?", time.ago) }

  def self.availabilities(date:, clubs:, duration: 90, updated_within: :if_old)
    availabilities = {}
    clubs.each do |club|
      availability =
        club.availability(
          date: date.to_date,
          duration: duration,
          updated_within: updated_within
        )
      availabilities[club] = availability if availability.present?
    end
    return availabilities
  end

  def self.new_availability_json(date)
    from = date.in_time_zone.change_hour_minutes("5:00")
    to = date.in_time_zone.change_hour_minutes("23:30")
    availability_json = Hash.new
    (from.to_i...to.to_i)
      .step(30.minutes)
      .map do |time_int|
        start_time = Time.at(time_int).in_time_zone
        availability_json[start_time] = Hash.new
      end
    return availability_json
  end
end


