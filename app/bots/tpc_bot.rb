class TpcBot
  include SeleniumDriver

  def availability(
    club_id: nil,
    date: Date.today,
    duration: 90,
    force_update: false
  )
    # club = Club.find club_id
    @club = Club.last
    @date = date
    @duration = duration
    url = @club.website
    begin
      create_driver
      @driver.get url
      sleep 3
      gs = @driver.find_elements(tag_name: "g")
      available_timeslots = parse_available_timeslots gs
      return available_timeslots
    rescue Exception => e
      p e
    ensure
      if @driver
        # @driver.close
        # @driver.quit
      end
    end
    return "Done it!"
  end

  def parse_available_timeslots(gs)
    slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }
    slots.map do |slot|
      s = slot.text.split("\n$")
      h = s[0].split "-"
      { starts_at: h[0], price: s[1].tr(".", "").to_i }
    end
  end

  def parse_courts(available_timeslots)
    text = available_timeslots.first.text
    courts = text.split("\n-\n").map { |court| court.tr("-\n", "") }.compact
  end
end
