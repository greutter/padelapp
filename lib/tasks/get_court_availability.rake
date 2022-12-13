namespace :get_court_availability do
  desc "Scrap availability for today at Santiago Oriente"
  task today: :environment do
    comunas = Comuna.where(sector: "Santiago Oriente").pluck("name")
    clubs = Club.where("comuna in (?)", comunas).active
    clubs.each do |club|
      club.availability(date: Date.today, duration: 90, force_update: true)
    end
  end

  desc "Scap availability near future"
  task next_two_weeks: :environment do
    comunas = Comuna.where(sector: "Santiago Oriente").pluck("name")
    clubs = Club.where("comuna in (?)", comunas).active
    clubs.each do |club|
      (Date.tomorrow...(Date.tomorrow + 6.days)).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, force_update: false)
      end
    end
  end
end
