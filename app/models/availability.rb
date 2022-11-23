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

   scope :updated_within_5_min, -> { where('created_at > ?', 1000.minutes.ago) }
   
   def self.availabilities(date: , clubs: , duration: 90)
      availabilities = {}
      clubs.each do |club|
         availabilities[club] = club.availability(date: date.to_date, duration: duration)
      end
      return availabilities
   end
end
