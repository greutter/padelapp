#
# club = Club.(name: "Country Club",
#             address: "Las Arañas 1901, La Reina, Santiago",
#             google_maps_link: "https://goo.gl/maps/dSWzJfoyJYHC7a6E6")
#
# club.schedules.create(opens_at: DateTime.new.change({hour:9, minute: 30}),
#                             closes_at: DateTime.new.change({hour: 23, minute: 30}))
#
# Court.create([{club: club, number: 1}, {club: club, number: 2}])
