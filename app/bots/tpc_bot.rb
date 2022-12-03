class TpcBot
  include SeleniumDriver

  attr_accessor :club

  def initialize(club)
    self.club = club
  end

  def availability(date: Date.today, duration: 90, force_update: false)
    @date = date
    @duration = duration
    begin
      at = get_availability_table
      available_timeslots = parse_available_timeslots at
    rescue Exception => e
      p e
    ensure
      if @driver
        # @driver.close
        # @driver.quit
      end
    end
    return available_timeslots
  end

  def get_availability_table
    url = self.club.website
    create_driver
    @driver.get url
    sleep 3
    @driver.find_elements(tag_name: "g")
  end

  def parse_available_timeslots(gs)
    slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }
    ats =
      slots.map do |slot|
        s = slot.text.split("\n$")
        h = s[0].split "-"
        at = {
          starts_at: @date.to_time.change_hour_minutes(h[0]),
          ends_at: @date.to_time.change_hour_minutes(h[1]),
          price: s[1].tr(".", "").to_i
        }
      end
    return ats
  end

  def parse_courts()
    table = get_availability_table
    th = table.first #primera fila de la tabla
    text = th.text
    courts = text.split("\n-\n").map { |court| court.tr("-\n", "") }.compact
    courts.map! do |court|
      court.slice! "Padel"
      { number: court.scan(/\d+/).first.to_i, name: court.tr("0-9", "").strip }
    end
    courts.each { |court| club.courts.create(court) }
  end
end
