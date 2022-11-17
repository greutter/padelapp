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

   scope :updated_within_5_min, -> { where('updated_at > ?', 5.minutes.ago) }
   
   def get_availability(date: Date.today, clubs: Club.first, duration: 90)
      clubs_availability = clubs.map do |club| 
         [club.id, club.availability(date: @selected_date)]
      end      
      # time_range = (@selected_date.to_time.change(hour: 7).to_i...@selected_date.to_time.change(hour: 23).to_i)
      # time_range.step(30.minutes).each do |t|
      #    time = Time.at t
      #    @availability.each do |key, value|
      #       .list-group-item
      #       = Club.find(key).name
            
      #       if  @availability[key][time].nil?
      #          No hay canchas
      #       else 
      #          #{@availability[key][time][:courts].count} #{"cancha".pluralize @availability[key][time][:courts].count} disponibles
      #          Desde: $#{@availability[key][time][:courts].map{|c| c[:price]}.min}
      #       end
      #    end
      # end
   end
end
