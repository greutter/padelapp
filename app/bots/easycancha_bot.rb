class EasycanchaBot
  include EasycanchaReservationService
  def create_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--window-size=600,1200")
    options.add_argument("--headless")
    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps.accept_insecure_certs = true
    @driver =
      Selenium::WebDriver.for :chrome, capabilities: caps, options: options
    @driver.manage.timeouts.implicit_wait = 5000
    return @driver
  end

  def login(username: "reutter.carvajal@gmail.com", password: "ec1234")
    create_driver
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

  def get_availability(club_id: 502, date: Time.now + 1.days, timespan: 90)
    url =
      "https://www.easycancha.com/api/sports/7/clubs/#{club_id}/timeslots?date=#{date.strftime "%Y-%m-%d"}&time=05:00:00&timespan=#{timespan}"
    create_driver
    begin
      login
      # agent = Mechanize.new
      # page = agent.get(url)
      @driver.get(url)
      body = @driver.find_element(tag_name: "pre").text

      json = JSON.parse(body)
      if not(json["alternative_timeslots"].nil?) and
           json["alternative_timeslots"].any?
        hours =
          available_timeslots =
            json["alternative_timeslots"].map do |ats|
              a = ats["hour"].split(":")
              starts_at = date.to_time.change(hour: a[0], min: a[1])
              ends_at = starts_at + timespan.minutes
              { starts_at: starts_at, ends_at: ends_at }
            end
      end
      return { club_id => available_timeslots }
    rescue Exception => e
      puts e.message
    ensure
      @driver.close()
      @driver.quit()
    end
  end

  def create_clubs
    file = File.read("./app/bots/easy_cancha_clubs.json")
    clubs = JSON.parse!(file)["clubs"]

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
      club.comuna = club_hash["locality"]
      club.region = club_hash["region"]
      club.phone = club_hash["phone"]
      club.latitude = club_hash["latitude"]
      club.longitude = club_hash["longitude"]
      p club.save!
    end
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
