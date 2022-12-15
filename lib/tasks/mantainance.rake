desc "Check clubs active state"
task detect_active_clubs: :environment do |task, args|
    EasycanchaBot.new(Club.new).create_clubs
    Club.all.each do |club|
        if club.availabilities.where("created_at > ?", 1.day.ago).any?
            puts "ACTIVE: #{club.name}"
        else
            club.availability date: Date.tomorrow, updated_within: :force_update
            if club.availabilities.where("created_at > ?", 1.day.ago).any?
                club.update active: true
                puts "ACTIVATING: #{club.name}"
            else 
                club.update active: false
                puts "INACTIVE: #{club.name}"
            end
        end
    end
end