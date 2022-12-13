module SeleniumDriver
  def create_driver(club: nil)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--no-sandbox') 
    options.add_argument("--window-size=600,1200")
    options.add_argument("--headless") if Rails.env.production? or true
    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    caps.accept_insecure_certs = true
    @driver =
      Selenium::WebDriver.for :chrome, capabilities: caps, options: options
    @driver.manage.timeouts.implicit_wait = 5
    return @driver
  end

  def driver 
    @driver 
  end

  def quit 
    @driver.quit if @driver 
  end

  def wait(timeout = 10)
    Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  # def screenshot
  #   @driver.save_screenshot("./app/assets/images/screenshots/screenshot.png") if Rails.env.development?
  # end
end
