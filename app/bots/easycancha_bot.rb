class EasycanchaBot
  include EasycanchaReservationService
  def create_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--window-size=600,1200")
    # options.add_argument("--headless")
    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps.accept_insecure_certs = true
    @driver =
      Selenium::WebDriver.for :chrome, capabilities: caps, options: options
    @driver.manage.timeouts.implicit_wait = 5000
    return @driver
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

  def availability(club_id:, date:, duration: 90)
    club = Club.find(club_id)
    url =
      "https://www.easycancha.com/api/sports/7/clubs/#{club.third_party_id}/timeslots?date=#{date.strftime "%Y-%m-%d"}&time=05:00:00&timespan=#{duration}"
    begin
      return "members_only" if club.members_only?
      create_driver
      @driver.get(url)
      body = @driver.find_element(tag_name: "pre").text
      available_timeslots =
        parse_available_timeslots(body, date: date, duration: duration)
      if available_timeslots.nil?
        # login
        # @driver.get(url)
        # body = @driver.find_element(tag_name: "pre").text
        # available_timeslots =
        # parse_available_timeslots(body, date: date, duration: duration)
      end
      return available_timeslots
    rescue Exception => e
      puts e.message
    ensure
      @driver.close()
      @driver.quit()
    end
  end

  def parse_available_timeslots(json, date: , duration: )
    # json["alternative_timeslots"][0]["timeslots"][0]["priceInfo"]["amount"]
    json = JSON.parse(json)
    if not(json["alternative_timeslots"].nil?) and
         json["alternative_timeslots"].any?
      hours =
        available_timeslots =
          json["alternative_timeslots"].map do |ats|
            a = ats["hour"].split(":")
            starts_at = date.to_time.change(hour: a[0], min: a[1])
            ends_at = starts_at + duration.minutes
            courts =
              ats["timeslots"].map do |ts|
                { "number" => ts["courtNumber"], "price" => ts["priceInfo"]["amount"] }.stringify_keys
              end
            [
              starts_at,
              { starts_at: starts_at, duration: duration, ends_at: ends_at, courts: courts }.stringify_keys
            ]
          end
    end
    return available_timeslots.to_h.stringify_keys
  end

  def create_clubs
    begin
      puts "Fetching and creating Easycancha Clubs"
      create_driver
      login
      @driver.get("https://www.easycancha.com/api/clubs/")
      body = @driver.find_element(tag_name: "pre").text
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
        club.save!
      end
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      @driver.close()
      @driver.quit()
    end
  end

  def get_driver(logged_in = false)
    if @driver.nil?
      create_driver
      login if logged_in
    end
    return @driver
  end

  def quit_driver
    @driver.quit if @driver
  end

  private

  def put_separator
    puts "****************"
    puts "****************"
    puts "****************"
  end

  def wait(timeout = 5000)
    @wait = Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def screenshot
    @driver.save_screenshot("./app/assets/images/screenshots/screenshot.png")
  end
end
