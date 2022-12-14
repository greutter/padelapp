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

  scope :updated_within, -> (time = 10.minutes) { where("created_at > ?", Time.now - time) }

  def self.availabilities(date: ,clubs: ,duration: 90, updated_within: :if_old)
    availabilities = {}
    clubs.each do |club|
      availability =  
        club.availability(
          date: date.to_date, duration: duration, updated_within: updated_within
        )
      if availability.present?
        availabilities[club] = availability
      end
    end
    return availabilities
  end
end
