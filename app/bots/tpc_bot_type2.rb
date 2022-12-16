module TpcBotType2
  
  def parse_available_timeslots_type2(date:, duration: 90, courts: [])
    table_body = @driver.find_element css: "#CuerpoTabla"
    ats = []
    (1..club.courts.count).each do |court_number|
      court = club.courts.find_or_create_by(number: court_number)
      p "Court: #{court.number}"
      court_available_slots = Array.new
      number_of_rows = table_body.find_elements(css: "g[x='0']").count
      (-1..(number_of_rows - 3)).each do |row|
        hour_rect =
          table_body.find_element(css: "g[y='#{row}'][x='#{court_number - 1}']")
        start_time_rects =
          hour_rect.find_elements(css: "rect[habilitado='true']")
        start_time_rects.each do |start_time_rect|
          p hour = start_time_rect.attribute("time")
          starts_at = date.in_time_zone.change_hour_minutes(hour)
          begin
            start_time_rect.click
            sleep 0.5
          rescue Exception => e
            p "Open dialog intecepted... "
            next
          end
          reservation_dialog = @driver.find_element(css: "#dialogReserva")
          info_array = reservation_dialog.text.split("\n")
          p info_array

          if info_array.include? "#{duration}' Defecto"
            date = current_selected_date
            "starts_at: #{starts_at}"
            ats << {
              "starts_at" => starts_at,
              "ends_at" => starts_at + duration.minutes,
              "court" => {
                "id" => court.id,
                "number" => court.number,
                "price" => nil
              }
            }
          end
          begin
            @driver.find_element(css: ".ui-dialog-titlebar-close").click
          rescue Exception => e
            p "Close dialog..."
          end
        end
      end
    end
    return to_availability_by_start_time_type1(ats)
  end
end

# def foo
#   gs = @driver.find_elements(tag_name: "g")
#   slots = gs.filter { |g| g.attribute("id").match /ocupacion_/ }
#   if slots.blank?
#     return nil
#   else
#     ats =
#       slots.map do |slot|
#         x_coordinate = slot.find_element(tag_name: "rect").attribute("x").to_i
#         y_coordinate = slot.find_element(tag_name: "rect").attribute("y").to_i
#         s = slot.text.split("\n$")
#         h = s[0].split "-"
#         court =
#           club.courts.find_or_create_by(number: get_court_by(x_coordinate))
#         price = (s[1].tr(".", "").to_i unless s[1].blank?)
#         {
#           "court" => {
#             "id" => court.id,
#             "number" => court.number,
#             "price" => price
#           },
#           "starts_at" => date.in_time_zone.change_hour_minutes(h[0]),
#           "ends_at" => date.in_time_zone.change_hour_minutes(h[1]),
#           "table_coordinates" => {
#             "x" => x_coordinate,
#             "y" => y_coordinate
#           }
#         }
#       end
#     available_time_slots = to_available_time_slots(ats)
#     return available_time_slots.to_h.stringify_keys
#   end
# end
