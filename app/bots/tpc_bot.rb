class TpcBot
  include SeleniumDriver
  include TpcBotType1
  include TpcBotType2

  attr_accessor :club

  def initialize(club)
    self.club = club
  end

  def initialize_driver
    if @driver.nil?
      # begin
      create_driver
      url = self.club.website
      @driver.get url
      accept_cokies
      sleep 1
      # rescue StandardError => e
      # p e
      # end
    end
    return @driver
  end

  def accept_cokies
    wait_2 =
      Selenium::WebDriver::Wait.new(
        timeout: 3,
        message: "Timed out cookies acceptance",
        ignore: Selenium::WebDriver::Error::NoSuchElementError
      )
    begin
      accept_cokies_btn =
        wait_2.until do
          @driver.find_element(css: "#ctl00_ButtonPermitirNecesarios")
        end
      accept_cokies_btn.click if accept_cokies_btn.present?
    rescue Exception => e
      p e
    end
  end

  def availability(date, duration: 90)
    initialize_driver
    begin
      select_date(date)
      if current_selected_date_match? date
        case club.third_party_software
        when "tpc_matchpoint_1"
          p "Scraping #{club.name} Tpc type 1"
          p Time.now
          return parse_available_timeslots_type1(date: date, duration: duration)
        when "tpc_matchpoint_2"
          p "Scraping #{club.name} Tpc type 2"
          p Time.now
          return parse_available_timeslots_type2(date: date, duration: duration)
        else
          raise StandardError.new "Third party software #{club.third_party_software} not found."
        end
      else
        return nil
      end
    rescue Exception => e
      p e
      return nil
    ensure
      @driver.quit if @driver
      p Time.now
    end
  end

  def login
    begin
      initialize_driver
      @driver.get "https://www.clubconecta.cl/Login.aspx"
      sleep 1
      login_input =
        @driver.find_element(
          css: "#ctl00_ContentPlaceHolderContenido_Login1_UserName"
        )
      login_input.send_keys("greutter@gmail.com")
      p password_input =
          @driver.find_element(
            css: "#ctl00_ContentPlaceHolderContenido_Login1_Password"
          )
      password_input.send_keys("Ffk3n5QM6GyZWgt")
      login_button =
        @driver.find_element(
          css: "#ctl00_ContentPlaceHolderContenido_Login1_LoginButton"
        )
      login_button.click
      return "@driver is now logged in."
    rescue Exception => e
      p e
    end
  end

  def create_courts()
    initialize_driver
    begin
      courts = driver.find_elements(css: "g[nombre]")
      courts.each do |court_node|
        court_h = {
          number: court_node.text.scan(/\d+/).first.to_i,
          name: court_node.text
        }
        court = club.courts.find_or_create_by(number: court_h[:number])
        court.update name: court_h[:name], active: true
      end
    rescue Exception => e
      p e
    ensure
      @driver.quit() if @driver
    end
  end

  def select_date(date)
    initialize_driver
    month = date.month
    day = date.day
    @driver.find_element(css: "#fechaTabla").click
    selector = "td[data-month=\"#{month - 1}\"]"
    data_month = wait.until { @driver.find_elements(css: selector) }
    if data_month.blank?
      return nil
    else
      day_link =
        data_month.find do |element|
          element.find_element(css: "a").attribute("innerHTML") == day.to_s
        end
      if day_link.nil?
        return nil
      else
        day_link.click
        # TODO: make it work:
        # wait.until { @driver.find_element(css: "g[y='#{1}'][x='#{1}']") }
        sleep 3
        return true
      end
    end
  end

  def current_selected_date
    Date.parse @driver.find_element(css: "#CuerpoTabla").attribute("time")
  end

  def current_selected_date_match?(date)
    if current_selected_date != date
      message =
        "Driver current selected date (#{current_selected_date}) mismatch with requested date: (#{date})"
      raise StandardError.new message
      return false
    end
    return true
  end
end
