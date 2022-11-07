class EasycanchaBot
  def self.create_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--window-size=600,1200")
    # options.add_argument('--headless')

    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps.accept_insecure_certs = true

    @driver =
      Selenium::WebDriver.for :chrome, capabilities: caps, options: options
    @driver.manage.timeouts.implicit_wait = 5000
    return @driver
  end

  def self.login(username: "reutter.carvajal@gmail.com", password: "ec1234")
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


  def self.availability(club_id: 502, date: Time.now + 1.days, timespan: 90)
    url =
      "https://www.easycancha.com/api/sports/7/clubs/#{club_id}/timeslots?date=#{date.strftime "%Y-%m-%d"}&time=05:00:00&timespan=#{timespan}"
    create_driver
    begin
      self.login()
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

  def self.reserve(club_id: 502, starts_at: DateTime.tomorrow, duration: 90)
    begin
      self.login()
      self.put_separator
      self.select_sport(club_id: club_id)
      sleep(2)
      self.select_duration(duration: 90)
      sleep(2)
      self.select_date()
      sleep(2)
      self.select_timeslot()
      sleep(2)
      self.screenshot
    rescue Exception => e
      puts e.message
    ensure
      @driver.close
      @driver.quit
      self.put_separator
    end
  end

  def self.select_sport(club_id: 502)
    begin
      puts "Selecting sport..."
      create_driver unless @driver
      @driver.get "https://www.easycancha.com/book/clubs/#{club_id}/sports?lang=es-CL&country=CL"
      sleep(2)
      @driver.find_elements(:xpath, "//div[normalize-space(text())='Padel']")[1].click
      return @driver
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
    end
  end

  def self.select_duration(duration: 90)
    begin
      puts "Selecting duration..."
      @driver.find_element(:xpath, "//div[normalize-space(text())='90']").click
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      return nil
    end
  end

  def self.select_date(date: Date.tomorrow)
    begin
      puts "Selecting date..."
      dates = @driver.find_elements(xpath: "//div[contains(@class, 'cds-day')]")
      date_ec = I18n.l(date, format: "%d\n%a.").upcase
      month = @driver.find_element(xpath: "//div[contains(@class, 'cds-month')]").text
      availabel_dates = dates.map do |d|
        day = d.text.split("\n")[0]
        [Date.parse("#{day}-#{month}"), d.text] 
      end
      p availabel_dates
      dates.last.click
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      return @driver
    end
  end

  def self.select_timeslot(start_time: "10:00")
    timeslots = @driver.find_elements(xpath: "//div[contains(@class, 'hour_item_number')]")
    if Rails.env.development?
      timeslots.first.click
    else
      timeslot = timeslots.select{|t| t.text == start_time}.first
      timeslot.click if timeslot
    end 
    sleep(2)
    @driver.find_element(xpath: "//a[normalize-space(text())='Siguiente']").click
  end

  def self.create_clubs
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

  def self.parse_date(date)

  end

  def self.put_separator
    puts "****************"
    puts "****************"
    puts "****************"
  end

  def self.wait(timeout = 5000)
    @wait = Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def self.screenshot
    @driver.save_screenshot("./app/assets/images/screenshots/screenshot.png")
  end
end

