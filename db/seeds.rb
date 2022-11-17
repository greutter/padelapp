# club =
#   Club.create(
#     name: "Pádel Panguipulli",
#     address: "J.B Etchegaray 062 Interior, Panguipulli",
#     google_maps_link: "https://goo.gl/maps/UJgvgrR7vJtWGPYRA",
#     phone: "56973962366"
#   )

# Court.create([{ club: club, number: 1 }, { club: club, number: 2 }])

club =
  Club.create(
    name: "Espacio Padel",
    address: "Nueva Bilbao #9495, Las Condes.",
    google_maps_link:
      "https://www.google.com/maps/place/Nueva+Bilbao+9495,+Las+Condes,+Regi%C3%B3n+Metropolitana/@-33.4292111,-70.5402009,15z/data=!4m5!3m4!1s0x9662ce7e626e986d:0x8ee7239893901862!8m2!3d-33.4292111!4d-70.5314462",
    phone: "56962949825"
  )

begin
  Club.find_by(third_party_id: 336).update(members_only: true)
rescue Exception => e
  p e
end

(1..3).each { |i| Court.create({ club: club, number: i }) }

Club.all.each do |club|
  (0..6).each do |wday|
    club.schedules.create(
      [
        {
          day_of_week: wday,
          opens_at: DateTime.parse("1981-05-03 8:30 -3") + wday.days,
          closes_at: DateTime.parse("1981-05-03 20:30 -3") + wday.days,
          tipo: "default"
        }
      ]
    )
  end
end

#Comunas
comunas = Club.all.map { |c| { name: c.comuna, region: c.region } }
Comuna.create(comunas)

sectors = [
  { name: "Padre Hurtado", sector: "Santiago Poniente" },
  { name: "Huechuraba", sector: "Santiago Norte" },
  { name: "Las Condes", sector: "Santiago Oriente" },
  { name: "La Florida", sector: "Santiago Sur" },
  { name: "Melipilla", sector: "" },
  { name: "Colina", sector: "Santiago Norte" },
  { name: "Lampa ", sector: "Santiago Norte" },
  { name: "Talagante", sector: "Santiago Poniente" },
  { name: "Maipú", sector: "Santiago Poniente" },
  { name: "San Bernardo", sector: "Santiago Sur" },
  { name: "Calera de Tango", sector: "Santiago Poniente" },
  { name: "Estación Central", sector: "Santiago Poniente" },
  { name: "Paine", sector: "Santiago Poniente" },
  { name: "Puente Alto", sector: "Santiago Sur" },
  { name: "Providencia", sector: "Santiago Oriente" },
  { name: "La Reina", sector: "Santiago Oriente" },
  { name: "Buin", sector: "Santiago Poniente" },
  { name: "Peñalolén", sector: "Santiago Oriente" },
  { name: "Vitacura", sector: "Santiago Oriente" }
]

sectors.each { |s| Comuna.find_by(name: s[:name]).update(sector: s[:sector]) }
