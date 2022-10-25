file = File.read("./lib/easy_cancha_scraper/clubs.json")
clubs = JSON.parse!(file)["clubs"]

clubs.select! { |club| club["sports"].select { |sport| sport["id"] == 7 }.any? }
p Club.count
p clubs.count
clubs.each do |club_hash|
  club =
    Club.find_or_create_by(
      third_party_id: club_hash["id"],
      third_party_software: "easycancha"
    )
  club.name = club_hash["name"]
  club.third_party_software = "easycancha"
  club.third_party_id = club_hash["id"]
  club.website = club_hash["website"]
  club.address = club_hash["address"]
  club.comuna = club_hash["locality"]
  club.region = club_hash["region"]
  club.phone = club_hash["phone"]
  club.latitude = club_hash["latitude"]
  club.longitude = club_hash["longitude"]
  p club.save!
end
