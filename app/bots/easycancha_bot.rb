class EasycanchaBot
  include EasycanchaReservationService
  include SeleniumDriver

  attr_accessor :club

  def initialize(club)
    self.club = club
  end

  def login(username: "reutter.carvajal@gmail.com", password: "ec1234")
    @driver.get "https://www.easycancha.com/book/search?lang=es-CL&country=CL"
    button =
      wait.until do
        @driver.find_element(
          :xpath,
          "//span[normalize-space(text())='Inicia sesión aquí']"
        )
      end
    sleep(3)
    button.click
    email_field = wait.until { @driver.find_element(:name, "email") }
    email_field.send_keys username
    password_field = @driver.find_element(:name, "password")
    password_field.send_keys password
    @driver.find_element(
      :xpath,
      "//button[normalize-space(text())='Ingresar']"
    ).click
    sleep(2)
    return @driver
  end

  def availability(date, duration: 90)
    url =
      "https://www.easycancha.com/api/sports/7/clubs/#{club.third_party_id}/timeslots?date=#{date.strftime "%Y-%m-%d"}&time=22:00:00&timespan=#{duration}"
    begin
      create_driver
      if club.members_only?
        login
        @driver.get(url)
        body = @driver.find_element(tag_name: "pre").text
        available_timeslots =
          parse_available_timeslots(body, date: date, duration: duration)
      else
        @driver.get(url)
        body = @driver.find_element(tag_name: "pre").text
        available_timeslots =
          parse_available_timeslots(body, date: date, duration: duration)
      end

      return available_timeslots
    rescue Exception => e
      puts e.message
    ensure
      @driver.quit() if @driver
    end
  end

  def parse_available_timeslots(json, date:, duration:)
    json = JSON.parse(json)
    available_time_slots = {}
    if json["alternative_timeslots"].present?
      json["alternative_timeslots"].each do |ats|
        a = ats["hour"].split(":")
        starts_at = date.in_time_zone.change(hour: a[0], min: a[1])
        ends_at = starts_at + duration.minutes
        courts = find_courts ats
        available_time_slots[starts_at] = {
          starts_at: starts_at,
          ends_at: ends_at,
          courts: courts
        }.stringify_keys
      end
    end
    return available_time_slots.stringify_keys
  end

  def find_courts(ats)
    ats["timeslots"].map do |ts|
      court = club.courts.find_or_create_by(number: ts["courtNumber"])
      court.update active: true unless court.active?
      {
        "number" => ts["courtNumber"],
        "price" => ts["priceInfo"]["amount"],
        "court_id" => court.id
      }.stringify_keys
    end
  end

  def create_clubs
    begin
      puts "Fetching and creating Easycancha Clubs"
      create_driver
      login
      @driver.get("https://www.easycancha.com/api/clubs/")
      body = @driver.find_element(tag_name: "pre").text
      puts body
      clubs = JSON.parse!(body)["clubs"]

      clubs.select! do |club|
        club["sports"].select { |sport| sport["id"] == 7 }.any?
      end
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
        club.latitude = club_hash["latitude"]
        club.comuna = club_hash["locality"]
        club.region = club_hash["region"]
        club.phone = club_hash["phone"]
        club.longitude = club_hash["longitude"]
        club.active = true
        club.save
      end
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      @driver.close()
      @driver.quit()
    end
  end

  private

  def put_separator
    puts "****************"
    puts "****************"
    puts "****************"
  end
end
