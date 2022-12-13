class TpcBot
  include SeleniumDriver

  attr_accessor :club

  def initialize(club)
    self.club = club
  end

  def initialize_driver
    if @driver.nil?
      create_driver
      url = self.club.website
      @driver.get url
      accept_cokies = wait.until {@driver.find_element(css: "#ctl00_ButtonPermitirNecesarios")}
      accept_cokies.click unless accept_cokies.nil?
  
    end
    return @driver
  end

  def driver 
    @driver 
  end

  def quit 
    @driver.quit if @driver 
  end

  def login
    begin
      initialize_driver if @driver.nil?
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

  def availability(date, duration: 90)
    initialize_driver if @driver.nil?
    begin      
      select_date(date)
      return parse_available_timeslots(date: date, duration: duration)
    rescue Exception => e
      p e
    ensure
      @driver.quit if @driver 
    end
    return nil
  end

  def start_times_of(ats)
    ats.map { |a| a["starts_at"] }.uniq!
  end

  # private

  def select_date(date)
    initialize_driver
    month = date.month
    day = date.day
    @driver.find_element(css: "#fechaTabla").click
    sleep 3
    selector = "td[data-month=\"#{month-1}\"]"
    data_month = wait.until {@driver.find_elements(css: selector)}

    if data_month.blank?
      return nil 
    else
      day_link = data_month.find do |element| 
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
    Date.parse @driver.find_element(css:"#CuerpoTabla").attribute("time")
  end
  
  def parse_available_timeslots(date:, duration: 90)
    if current_selected_date != date 
      message = "Driver current selected date (#{current_selected_date}) mismatch with requested date: (#{date})"
      raise StandardError.new message
      return nil
    else
      gs = @driver.find_elements(tag_name: "g")
      slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }
      if slots.blank? 
        return nil
      else 
        ats =
          slots.map do |slot|
            x = slot.find_element(tag_name: "rect").attribute("x").to_i
            y = slot.find_element(tag_name: "rect").attribute("y").to_i
            s = slot.text.split("\n$")
            h = s[0].split "-"
            price = (s[1].tr(".", "").to_i unless s[1].blank?)
            {
              "court" => {
                "number" => get_court_by(x),
                "price" => price
              },
              "starts_at" => date.to_time.change_hour_minutes(h[0]),
              "ends_at" => date.to_time.change_hour_minutes(h[1]),
              "table_rect_coord" => {
                "x" => x,
                "y" => y
              }
            }
          end
        available_time_slots = to_available_time_slots(ats)
        return available_time_slots
      end
    end
  end

  def to_available_time_slots(ats)
    start_times = start_times_of(ats)
    available_time_slots = {}
    start_times.each do |start_time|
      slots = ats.filter { |slot| slot["starts_at"] == start_time }
      courts = slots.map { |slot| slot["court"] }
      available_time_slots[start_time] = {
        "starts_at" => slots.first["starts_at"],
        "ends_at" => slots.first["ends_at"],
        "courts" => courts
      }
    end
    return available_time_slots.stringify_keys
  end

  def get_and_create_courts()
    initialize_driver if @driver.nil?
    begin 
      ths = @driver.find_elements(tag_name: "g").first
      p text = ths.text #primera fila de la tabla
      courts = text.split("\n-\n").map { |court| court.tr("-\n", "") }.compact
      courts.map! do |court|
        court.slice! "Padel"
        { number: court.scan(/\d+/).first.to_i, name: court.tr("0-9", "").strip }
      end
      courts.each { |court| club.courts.create(court) }
    rescue Exception => e
      p e 
    ensure
      @driver.quit() if @driver
    end
  end

  def get_court_by(x_coordinate)
    (x_coordinate - 50) / 120 + 1
  end
end
