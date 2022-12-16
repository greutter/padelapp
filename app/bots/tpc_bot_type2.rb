module TpcBotType2
  def parse_available_timeslots_type2(date:, duration: 90, courts: [])
    select_date date
    table_body = scrap_table_body
    available_slots = Availability.new_availability_json current_selected_date
    scraped_sts = scrap_start_times(table_body)
    courts = club.courts
    available_slots.each do |start_time, slot_info|
      if scraped_sts.keys.exclude? start_time
        next
      elsif start_time < Time.now.in_time_zone
        next
      else
        courts.each_with_index do |court, x|
          y = scraped_sts[start_time]
          if available_slots[start_time].present? and
               available_slots[start_time]["courts"].count >= 2
            next
          end
          begin
            hour_slot = table_body.find_element(css: "g[y='#{y}'][x='#{x}']")
            clickable_slots =
              hour_slot.find_elements(css: "rect[habilitado='true']")
            clickable_slots.first.click
            sleep 0.75
          rescue Exception => e
            p "Slot click failed"
            next
          end
          reservation_dialog = @driver.find_element(css: "#dialogReserva")
          if reservation_dialog and
               duration_available?(reservation_dialog, duration)
            if available_slots[start_time].blank?
              available_slots[start_time] = {
                starts_at: start_time,
                ends_at: start_time + duration.minutes,
                courts: [court_to_json(court)]
              }.stringify_keys
            else
              available_slots[start_time]["courts"] << court_to_json(court)
            end
          end
          close_reservation_dialog(reservation_dialog)
        end
      end
    end
    return available_slots
  end

  def court_to_json(court)
    { number: court.number, price: "", court_id: court.id }
  end

  def duration_available?(reservation_dialog, duration)
    info_array = reservation_dialog.text.split("\n")
    info_array.include? "#{duration}' Defecto"
  end

  def close_reservation_dialog(reservation_dialog)
    begin
      @driver.find_element(css: ".ui-dialog-titlebar-close").click
      return true
    rescue Exception => e
      p "Close dialog click failed"
      return false
    end
  end

  def scrap_table_body
    @driver.find_element css: "#CuerpoTabla"
  end

  def scrap_start_times(table_body)
    nodes = table_body.find_elements(css: "g[x='0']")
    start_times = Hash.new
    nodes.each do |node|
      date = current_selected_date
      start_time = date.in_time_zone.change_hour_minutes(node.text)
      start_times[start_time] = node.attribute "y"
    end
    return start_times
  end
end