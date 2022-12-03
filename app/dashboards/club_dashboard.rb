require "administrate/base_dashboard"

class ClubDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    address: Field::String,
    availabilities: Field::HasMany,
    city: Field::String,
    comuna: Field::String,
    courts: Field::HasMany,
    google_maps_link: Field::String,
    latitude: Field::Number,
    longitude: Field::Number,
    members_only: Field::Boolean,
    name: Field::String,
    phone: Field::String,
    region: Field::String,
    schedules: Field::HasMany,
    third_party_id: Field::Number,
    third_party_software: Field::String,
    website: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[id name comuna region].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    website
    phone
    address
    comuna
    city
    region
    website
    google_maps_link
    members_only
    third_party_software
    created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    phone
    address
    comuna
    city
    region
    google_maps_link
    website
    members_only
    third_party_software
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how clubs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(club)
  #   "Club ##{club.id}"
  # end
end
