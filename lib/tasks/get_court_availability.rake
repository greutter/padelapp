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
  task two_weeks_easycancha: :environment do |task, args|
    comunas = Comuna.where(sector: "Santiago Oriente").pluck("name")
    clubs = Club
            .where("comuna in (?) and third_party_software = 'easycancha'", comunas)
            .active
    clubs.each do |club|
      (Date.today...(Date.today + 14.days)).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, force_update: false)
      end
    end
  end

  desc "Scap availability near future"
  task one_week_tpc: :environment do |task, args|
    clubs = Club
            .where("third_party_software = ?", 'tpc_matchpoint')
            .active
    clubs.each do |club|
      (Date....(Date.today + 14.days)).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, force_update: false)
      end
    end
  end
end
