club = Club.create(name: "Pádel Panguipulli",
            address: "J.B Etchegaray 062 Interior, Panguipulli",
            google_maps_link: "https://goo.gl/maps/UJgvgrR7vJtWGPYRA",
            phone: "56973962366")


Court.create([{club: club, number: 1}, {club: club, number: 2}])

club = Club.create(name: "Espacio Padel",
    address: "Nueva Bilbao #9495, Las Condes.",
    google_maps_link: "https://www.google.com/maps/place/Nueva+Bilbao+9495,+Las+Condes,+Regi%C3%B3n+Metropolitana/@-33.4292111,-70.5402009,15z/data=!4m5!3m4!1s0x9662ce7e626e986d:0x8ee7239893901862!8m2!3d-33.4292111!4d-70.5314462",
    phone: "56962949825")

(1..10).each do |i|
    Court.create({club: club, number: i})
end