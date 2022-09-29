club = Club.create(name: "Pádel Panguipulli",
            address: "J.B Etchegaray 062 Interior, Panguipulli",
            google_maps_link: "https://goo.gl/maps/UJgvgrR7vJtWGPYRA")


Court.create([{club: club, number: 1}, {club: club, number: 2}])
