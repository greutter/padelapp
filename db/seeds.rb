club = Club.create(name: "Country Club",
            address: "Las Arañas 1901, La Reina, Santiago",
            google_maps_link: "https://goo.gl/maps/dSWzJfoyJYHC7a6E6")


Court.create([{club: club, number: 1}, {club: club, number: 2}])
