module AvailabilityHelper
    # def availabilties_by_slot(availabilities)
    #     availabilities_start_times(availabilities).map do |start_time|
    #         @availabilities.each {|a| a[:start_time]}
    #     end       
    # end

    def availabilities_start_times(availabilities)
        availabilities.values.map  do |availability| 
            availability.keys 
        end.flatten.uniq.sort
    end

    def availabilities_clubs(availabilities)
        @availabilities.map(&:keys).flatten.map do |c_id|
            Club.find c_id
        end
    end


end
