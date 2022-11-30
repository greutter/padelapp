namespace :get_court_availability do
  desc "I am short, but comprehensive description for my cool task"
  task today: :environment do
    comunas = Comuna.where(sector: "Santiago Oriente").pluck("name")
    clubs = Club.where("comuna in (?)", comunas)
    clubs.each do |club|
      club.availability(date: Date.today, duration: 90, force_update: true)
    end
  end
end
