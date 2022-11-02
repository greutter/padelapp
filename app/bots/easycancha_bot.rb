class EasycanchaBot

  def self.create_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--window-size=600,1200")
    # options.add_argument('--headless')

    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps.accept_insecure_certs = true
  
    @driver = Selenium::WebDriver.for :chrome, capabilities: caps, options: options
    @driver.manage.timeouts.implicit_wait = 5000
    return @driver
  end

  def self.login_to_easycancha(username, password)
    @driver.get "https://www.easycancha.com/book/search?lang=es-CL&country=CL" 
    button = wait.until { 
      @driver.find_element(:xpath, "//span[normalize-space(text())='Inicia sesión aquí']") }
    sleep(3)  
    button.click

    email_field = wait.until {@driver.find_element(:name, "email")}
    email_field.send_keys username
    password_field = @driver.find_element(:name, "password")
    password_field.send_keys password
    @driver.find_element(:xpath, "//button[normalize-space(text())='Ingresar']").click
    sleep(3)
  end

  def self.select_club_sport(club_id= 502, sport= "Padel")
    @driver.get "https://www.easycancha.com/book/clubs/#{club_id}/sports"
    button = wait.until {@driver.find_element(:xpath, "//div[normalize-space(text())='Padel']")}
    button.click
  end

  def self.availability(club_id= 366, date = Time.now + 1.days, timespan= 90)
    url = "https://www.easycancha.com/api/sports/7/clubs/#{club_id}/timeslots?date=#{date.strftime "%Y-%m-%d"}&time=05:00:00&timespan=#{timespan}"
    create_driver
    p @driver
    self.login_to_easycancha("greutter@gmail.com", "ec123456")
    # agent = Mechanize.new
    # page = agent.get(url)
    @driver.get(url)
    p body = @driver.find_element(tag_name: "pre").text
    @driver.close()
    @driver.quit()
    json = JSON.parse(body)
    if not(json["alternative_timeslots"].nil?) and json["alternative_timeslots"].any?
      hours = json["alternative_timeslots"].map do |ats| 
        a = ats["hour"].split(":") 
        starts_at = date.to_time.change(hour: a[0], min: a[1])
        ends_at = starts_at + timespan.minutes
        {starts_at: starts_at, ends_at: ends_at}
      end
    end
  end

  def self.wait(timeout= 5000)
    @wait = Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def self.quit
    @driver.quit
  end
end

