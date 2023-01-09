class PlaytomicBot
  
  attr_accessor :club
  
  def initialize(club)
    self.club = club
  end
  
  def self.create_clubs
    clubs_api_url = "https://playtomic.io/api/v1/tenants?user_id=me&coordinate=-33.44889%2C-70.669265&sport_id=PADEL&radius=50000&size=40&with_properties=true"
    agent = Mechanize.new 
    response_json = JSON.parse agent.get(clubs_api_url).body
    response_json.each do |club_json|
      properties = {
      name: club_json["tenant_name"],
      phone: club_json["properties"]["CONTACT_PHONE"],
      email: "",
      website: "",
      address: "#{club_json["address"]["street"].strip}, #{club_json["address"]["city"]}",
      city: "Santiago",
      comuna: club_json["address"]["city"],
      latitude: club_json["address"]["coordinate"]["lat"],
      longitude: club_json["address"]["coordinate"]["lon"],
      region: "Región Metropolitana de Santiago",
      third_party_software: "playtomic",
      third_party_id: club_json["tenant_id"],
      active: true,
      members_only: false
      }
      club = Club.find_or_create_by(third_party_id: properties[:third_party_id])
      club.update(properties)
      guiones_name = properties["name"].gsub(/[^\w\s]/,"").gsub("  "," ").gsub(" ","-").downcase
      url = "https://playtomic.io/#{guiones_name}/#{properties["third_party_id"]}]"
      club.update(website: url)
    end

    def create_courts
      clubs_api_url = "https://playtomic.io/api/v1/tenants?user_id=me&coordinate=-33.44889%2C-70.669265&sport_id=PADEL&radius=50000&size=40"
      agent = Mechanize.new 
      response_json = JSON.parse agent.get(clubs_api_url).body
    end

  end
end