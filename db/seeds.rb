begin
  Club.find_by(third_party_id: 336).update(members_only: true)
rescue Exception => e
  p e
end

Club.find_by(third_party_id: 1203)

Court.all.update_all active: true

club = Club.find_by("name like '%onecta Las Condes%'")
club.courts.where("number > 10").update_all(active: false)
