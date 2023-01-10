desc "Check clubs active state"
task detect_active_clubs: :environment do |task, args|
  EasycanchaBot.new(Club.new).create_clubs
  Club.all.each do |club|
    if club.availabilities.where("created_at > ?", 3.days.ago).any?
      puts "ACTIVE: #{club.name}"
    else
      club.update active: false
      puts "INACTIVE: #{club.name}"
      puts "Checkig for activity: #{club.name}"
      club.availability date: Date.tomorrow, update: :force
      if club.availabilities.where("created_at > ?", 3.day.ago).any?
        club.update active: true
        puts "ACTIVATING: #{club.name}"
      end
    end
  end
end

desc "Delete old availabilities"
task clean_availability_db: :environment do |task, args|
  Availability.where("date < ?", 14.days.ago).delete_all
  Availability
    .all
    .pluck(:date)
    .uniq
    .sort
    .each do |date|
      date = Date.parse date
      p last_time = date.end_of_day - 2.hours
      p first_time = date.end_of_day + 7.hours
      Availability.where(updated_at: (last_time..first_time)).delete_all
    end
end
