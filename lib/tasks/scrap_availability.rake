namespace :scrap_availability do
  desc "Scrap availability for today at Santiago Oriente"
  task today: :environment do
    comunas =
      Comuna.where(región: "Región Metropolitana de Santiago").pluck("name")
    clubs = Club.where("comuna in (?)", comunas).active
    clubs.each do |club|
      club.availability(date: Date.today, duration: 90, force_update: :if_old)
    end
  end

  desc "Scrap availability easycancha for Region Metropolitana"
  task easycancha: :environment do |task, args|
    comunas =
      Comuna.where(region: "Región Metropolitana de Santiago").pluck("name")
    clubs =
      Club.where(
        "comuna in (?) and third_party_software = 'easycancha'",
        comunas
      ).active
    clubs.each do |club|
      (Date.today...(Date.today + 14.days)).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, updated_within: :if_old)
      end
    end

    (Date.today...(Date.today + 10.days)).each do |date|
      Club.find_by("name LIKE '%lba%'").availability date: date,
                     duration: 60,
                     updated_within: :force_update
    end
  end

  desc "Scrap availability tpc_matchpoint_1"
  task tpc_1: :environment do |task, args|
    from = Date.today
    to = from + 4.days
    clubs = Club.where("third_party_software = ?", "tpc_matchpoint_1").active
    clubs.each do |club|
      (from..to).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, updated_within: :if_old)
      end
    end
  end

  desc "Scrap availability tpc_matchpoint_2"
  task tpc_2: :environment do |task, args|
    from = Date.today
    to = from + 4.days
    clubs = Club.where("third_party_software = ?", "tpc_matchpoint_2").active
    clubs.each do |club|
      (from..to).each do |date|
        p "Scraping #{club.name} on #{date}"
        club.availability(date: date, duration: 90, updated_within: :if_old)
      end
    end
  end
end
