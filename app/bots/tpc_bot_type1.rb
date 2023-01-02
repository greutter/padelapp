module TpcBotType1
  def parse_available_timeslots_type1(date:, duration: 90)
    gs = @driver.find_elements(tag_name: "g")
    slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }
    available_slots = Availability.new_availability_json date
    if slots.blank?
      return {}
    else
      slots.each do |slot|
        y_coordinate = slot.find_element(tag_name: "rect").attribute("y").to_i
        h = slot.text.split("\n$")[0].split("-")
        court = parse_court_type1(slot)
        next if court.nil?
        starts_at = date.in_time_zone.change_hour_minutes(h[0])
        ends_at = date.in_time_zone.change_hour_minutes(h[1])
        next if ends_at != starts_at + duration.minutes
        if available_slots[starts_at].blank?
          available_slots[starts_at] = {
            "starts_at" => starts_at,
            "ends_at" => ends_at,
            "y" => y_coordinate,
            "courts" => [court]
          }
        else
          available_slots[starts_at]["courts"] << court
        end
      end
      return available_slots
    end
  end

  def parse_court_type1(slot)
    x_coordinate = slot.find_element(tag_name: "rect").attribute("x").to_i
    width = slot.find_element(tag_name: "rect").attribute("width").to_i
    court_number = (x_coordinate - 50) / width + 1
    court = club.courts.find_or_create_by(number: court_number)
    s = slot.text.split("\n$")
    price = s[1].blank? ? "" : s[1].tr(".", "").to_i
    if court.active?
      return(
        {
          court_number: court.number,
          price: price,
          court_id: court.id,
          x_coordinate: x_coordinate
        }.stringify_keys
      )
    end
  end
end
