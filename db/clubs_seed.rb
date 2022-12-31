Club.where("third_party_software LIKE '%tpc%'")

Club.create(
  name: "Club Conecta La Dehesa",
  address: "Luis Bascuñan 1858",
  city: "Santiago",
  comuna: "Lo Barnechea",
  google_maps_link: "https://goo.gl/maps/oXfS3C4TCzgdMJ3K9",
  phone: "+56974781499",
  region: "Región Metropolitana de Santiago",
  third_party_software: "tpc_matchpoint_1",
  website: "https://www.clubconecta.cl/Pages/15-CLUB_CONECTA_LA_DEHESA_PADEL",
  active: true,
  members_only: false,
  tps_id: 9001
)

Club.create(
  name: "Club Conecta Las Condes",
  address: "Av. Las Condes 12.560",
  city: "Santiago",
  comuna: "Las Condes",
  google_maps_link: "https://goo.gl/maps/Rwf1ZWqmhneTv4wR8",
  phone: "+56 9 74781499",
  region: "Región Metropolitana de Santiago",
  third_party_software: "tpc_matchpoint_1",
  website: "https://www.clubconecta.cl/Pages/17-CLUB_CONECTA_LAS_CONDES",
  active: true,
  members_only: false,
  tps_id: 9001
)

Club.create(
  name: "Más Padel Club",
  address: "Camino San Francisco De Asis 199",
  city: "Santiago",
  comuna: "Las Condes",
  google_maps_link: "https://goo.gl/maps/MQT2fWh8vobF3cTk9",
  phone: "+569 3752 1150",
  region: "Región Metropolitana de Santiago",
  third_party_software: "tpc_matchpoint_1",
  website: "http://www.maspadel.cl/Booking/Grid.aspx",
  active: true,
  members_only: false,
  tps_id: 9003
)

Club.create(
  name: "Espacio Padel",
  phone: "+56962949825",
  address: "Nueva Bilbao 9495",
  city: "Santiago",
  comuna: "Las Condes",
  google_maps_link: "https://goo.gl/maps/6Ciaa6tnRrHKquPc9",
  region: "Región Metropolitana de Santiago",
  third_party_software: "tpc_matchpoint_2",
  website: "https://espaciopadelcl.matchpoint.com.es/Booking/Grid.aspx",
  active: true,
  members_only: false,
  tps_id: 9101
)



Club.create(
  name: "Padel Estoril",
  phone: "+569 88237776",
  email: "padelestoril@gmail.com",
  website: "https://padelestorilcl.matchpoint.com.es/Booking/Grid.aspx",
  address: "Av Las Condes 10480",
  city: "Santiago",
  comuna: "Vitacura",
  region: "Región Metropolitana de Santiago",
  google_maps_link: "https://goo.gl/maps/ndT1ZqqdXePp7zPy6",
  third_party_software: "tpc_matchpoint_2",
  active: true,
  members_only: false,
  tps_id: 9102
)


Club.create(
  name: "Padel Cerro Calan",
  phone: "+56931464356",
  email: "padelcerrocalan@gmail.com",
  website: "https://padelcerrocalancl.matchpoint.com.es/Booking/Grid.aspx",
  address: "Paul Harris 9388",
  city: "Santiago",
  comuna: "Las Condes",
  region: "Región Metropolitana de Santiago",
  google_maps_link:
    "https://padelcerrocalancl.matchpoint.com.es/Booking/Grid.aspx",
  third_party_software: "tpc_matchpoint_2",
  active: true,
  members_only: false,
  tps_id: 9103
)

club =
  Club.create(
    name: "Padel Rinconada",
    phone: "+56 9 6776 3963",
    email: "padelrinconada@gmail.com",
    website: "https://padelrinconadacl.matchpoint.com.es/Booking/Grid.aspx",
    address: "La Rinconada 535",
    city: "Santiago",
    comuna: "Huechuraba",
    region: "Región Metropolitana de Santiago",
    google_maps_link: "https://goo.gl/maps/WAwg9ZfGczcoduPp7",
    third_party_software: "tpc_matchpoint_2",
    active: true,
    members_only: false,
    tps_id: 9105
  )

  club =
  Club.create(
    name: "Red Padel",
    phone: "+56 9 9005 6171",
    email: "redpadelclub@gmail.com",
    website: "http://www.redpadel.cl/Booking/Grid.aspx",
    address: "Av. Vitacura 8751",
    city: "Santiago",
    comuna: "Vitacura",
    region: "Región Metropolitana de Santiago",
    google_maps_link: "https://goo.gl/maps/1doA9izDdY6g6tW58",
    third_party_software: "tpc_matchpoint_2",
    active: true,
    members_only: false,
    tps_id: 9106
  )
  
  # club =
  # Club.create(
  #   name:,
  #   phone:,
  #   email:,
  #   website:,
  #   address:,
  #   city:,
  #   comuna:,
  #   region:,
  #   google_maps_link:,
  #   third_party_software:,
  #   active: true,
  #   members_only: false,
  #   tps_id: 9104
  # )

  