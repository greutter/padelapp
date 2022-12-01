module SeleniumDriver

    def create_driver(club: nil)
        @club = club unless club.nil?
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("--window-size=600,1200")
        options.add_argument("--headless") if Rails.env.production? or true
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps.accept_insecure_certs = true
        @driver =
        Selenium::WebDriver.for :chrome, capabilities: caps, options: options
        @driver.manage.timeouts.implicit_wait = 5000
        return @driver
    end
end