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
      create_driver
      url = self.club.website
      @driver.get url
      accept_cokies =
        wait.until do
          @driver.find_element(css: "#ctl00_ButtonPermitirNecesarios")
        end
      accept_cokies.click unless accept_cokies.nil?
      sleep 2
    end
    return @driver
  end

  def availability(date, duration: 90)
    initialize_driver
    begin
      select_date(date)
      sleep 2
      if current_selected_date_match? date
        case club.third_party_software
        when "tpc_matchpoint_1"
          p "Scraping #{club.name} Tcp type 1"
          p Time.now
          return parse_available_timeslots_type1(date: date, duration: duration)
        else
          p "Scraping #{club.name} Tcp type 2"
          p Time.now
          return parse_available_timeslots_type2(date: date, duration: duration)
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
    initialize_driver if @driver.nil?
    begin
      ths = @driver.find_elements(tag_name: "g").first
      p text = ths.text #primera fila de la tabla
      courts = text.split("\n-\n").map { |court| court.tr("-\n", "") }.compact
      courts.map! do |court|
        court.slice! "Padel"
        {
          number: court.scan(/\d+/).first.to_i,
          name: court.tr("0-9", "").strip
        }
      end
      courts.each { |court| club.courts.create(court) }
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
    sleep 3
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
