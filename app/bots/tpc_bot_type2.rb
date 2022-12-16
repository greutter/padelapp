module TpcBotType2
  def parse_available_timeslots_type2(date:, duration: 90, courts: [])
    select_date date
    table_body = get_table_body
    available_slots = Availability.new_availability_json date
    scraped_sts = scrap_start_times(table_body)
    courts = club.courts.first(2)
    available_slots.each do |start_time, slot_info|
      puts "start_time: #{start_time} #{slot_info}"
      puts scraped_sts[start_time]
      courts.each_with_index do |court, x|
        p "Court: #{court.number} x: #{x}"

        begin
          clickable_slot = table_body.find_element(css: "g[y='#{y}'][x='#{x}']")
          clickable_slot.click
        rescue Exception => e
          p e
          raise StandardError.new "Slot click intercepted "
        end

        return(
          table.clickable_slot.find_elements(css: "rect[habilitado='true']")
        )
      end
    end

    # start_time_rects.each do |start_time_rect|
    #   p hour = start_time_rect.attribute("time")
    #   starts_at = date.in_time_zone.change_hour_minutes(hour)
    #   begin
    #     start_time_rect.click
    #     sleep 0.5
    #   rescue Exception => e
    #     p "Open dialog intecepted... "
    #     next
    #   end
    #   reservation_dialog = @driver.find_element(css: "#dialogReserva")
    #   info_array = reservation_dialog.text.split("\n")
    #   p info_array

    #   # if info_array.include? "#{duration}' Defecto"
    #   #   date = current_selected_date
    #   #   "starts_at: #{starts_at}"
    #   #   ats << {
    #   #     "starts_at" => starts_at,
    #   #     "ends_at" => starts_at + duration.minutes,
    #   #     "court" => {
    #   #       "id" => court.id,
    #   #       "number" => court.number,
    #   #       "price" => nil
    #   #     }
    #   #   }
    #   # end
    #   # begin
    #   #   @driver.find_element(css: ".ui-dialog-titlebar-close").click
    #   # rescue Exception => e
    #   #   p "Close dialog..."
    #   # end
    # end

    return available_slots
  end

  def get_table_body
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

#   def old(date:, duration: 90, courts: [])
#     table_body = @driver.find_element css: "#CuerpoTabla"
#     ats = []
#     (1..club.courts.count).each do |court_number|
#       court = club.courts.find_or_create_by(number: court_number)
#       p "Court: #{court.number}"
#       court_available_slots = Array.new
#       number_of_rows = table_body.find_elements(css: "g[x='0']").count
#       (-1..(number_of_rows - 3)).each do |row|
#         hour_rect =
#           table_body.find_element(css: "g[y='#{row}'][x='#{court_number - 1}']")
#         start_time_rects =
#           hour_rect.find_elements(css: "rect[habilitado='true']")
#         start_time_rects.each do |start_time_rect|
#           p hour = start_time_rect.attribute("time")
#           starts_at = date.in_time_zone.change_hour_minutes(hour)
#           begin
#             start_time_rect.click
#             sleep 0.5
#           rescue Exception => e
#             p "Open dialog intecepted... "
#             next
#           end
#           reservation_dialog = @driver.find_element(css: "#dialogReserva")
#           info_array = reservation_dialog.text.split("\n")
#           p info_array

#           if info_array.include? "#{duration}' Defecto"
#             date = current_selected_date
#             "starts_at: #{starts_at}"
#             ats << {
#               "starts_at" => starts_at,
#               "ends_at" => starts_at + duration.minutes,
#               "court" => {
#                 "id" => court.id,
#                 "number" => court.number,
#                 "price" => nil
#               }
#             }
#           end
#           begin
#             @driver.find_element(css: ".ui-dialog-titlebar-close").click
#           rescue Exception => e
#             p "Close dialog..."
#           end
#         end
#       end
#     end
#     return to_availability_by_start_time_type1(ats)
#   end
# end
