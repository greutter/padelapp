class TpcBot
  include SeleniumDriver

  attr_accessor :club

  def initialize(club)
    self.club = club
    create_driver
    url = self.club.website
    @driver.get url
    sleep 12
  end

  def driver
    @driver
  end

  def availability(date: Date.today, duration: 90)
    begin
      #TODO: Here selection of date in browser is selected 
      return parse_available_timeslots(date: date, duration: duration)
    rescue Exception => e
      p e
    end
  end


  def parse_available_timeslots(date: , duration: 90)
    p date
    # begin
      gs = @driver.find_elements(tag_name: "g")
      slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }

      ats = slots.map do |slot|
        x = slot.find_element(tag_name: "rect").attribute("x").to_i
        y = slot.find_element(tag_name: "rect").attribute("y").to_i
        s = slot.text.split("\n$")
        h = s[0].split "-"
        price = (s[1].tr(".", "").to_i unless s[1].blank?),
        {
          court: {number: get_court_by(x), price: price},
          starts_at: date.to_time.change_hour_minutes(h[0]),
          ends_at: date.to_time.change_hour_minutes(h[1]),
          table_rect_coord: {x: x, y: y}
        }.stringify_keys
      end
      # available_time_slots = to_available_time_slots(ats)
      return slots
      # return 
    # rescue Exception => e
    #   p e 
    # ensure
      @driver.quit if @driver
    # end
  end
  
  def to_available_time_slots(ats)
    # start_times = start_times_of(ats)
    # available_time_slots = {}
    # start_times.each do |start_time|
    #   slots = ats.filter { |slot| slot["starts_at"] == start_time }
    #   courts = slots.map { |slot| slot["court"] }
    #   available_time_slots[start_time] = 
    #     {
    #       starts_at: slots.first["starts_at"],
    #       ends_at: slots.first["ends_at"],
    #       courts: courts
    #     }
    # end

  end

  def start_times_of(ats)
    ats.map {|a| a["starts_at"] }.uniq!
  end

  def parse_courts()
    ths = @driver.find_elements(tag_name: "g").first
    p text = ths.text #primera fila de la tabla
    courts = text.split("\n-\n").map { |court| court.tr("-\n", "") }.compact
    courts.map! do |court|
      court.slice! "Padel"
      { number: court.scan(/\d+/).first.to_i, name: court.tr("0-9", "").strip }
    end
    courts.each { |court| club.courts.create(court) }
  end

  def get_court_by(x_coordinate)
    (x_coordinate - 50)/120 + 1
  end
end
