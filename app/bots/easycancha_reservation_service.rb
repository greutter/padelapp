module EasycanchaReservationService
  def reserve(club_id: 336, starts_at: DateTime.tomorrow, duration: 90)
    begin
      login
      put_separator
      select_sport(club_id: club_id)
      sleep(2)
      select_duration(duration: duration)
      sleep(3)
      select_date(date: starts_at.to_date)
      sleep(2)
      select_timeslot
      sleep(2)
      select_court
      sleep(2)
      add_players
      sleep(4)
      complete_reservation
      sleep(2)
      screenshot if Rails.env.development?
    rescue Exception => e
      puts e.message
    ensure
      @driver.close
      @driver.quit
      put_separator
    end
  end

  def select_sport(club_id: 502)
    begin
      puts "Selecting sport..."
      create_driver unless @driver
      @driver.get "https://www.easycancha.com/book/clubs/#{club_id}/sports?lang=es-CL&country=CL"
      sleep(2)
      @driver.find_elements(:xpath, "//div[normalize-space(text())='Padel']")[
        1
      ].click
      return @driver
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
    end
  end

  def select_duration(duration: 90)
    begin
      puts "Selecting duration..."
      @driver.find_element(:xpath, "//div[normalize-space(text())='90']").click
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      return nil
    end
  end

  def select_date(date:)
    begin
      puts "Selecting date..."
      dates = @driver.find_elements(xpath: "//div[contains(@class, 'cds-day')]")
      date_ec = I18n.l(date, format: "%d\n%a.").upcase
      month =
        @driver.find_element(xpath: "//div[contains(@class, 'cds-month')]").text
      availabel_dates =
        dates.map do |d|
          day = d.text.split("\n")[0]
          [Date.parse("#{day}-#{month}"), d.text]
        end
      dates.last.click
    rescue Exception => e
      puts "Error: #{e.message}"
    ensure
      return @driver
    end
  end

  def select_timeslot(start_time: "10:00")
    puts "Selecting timeslot"
    timeslots =
      @driver.find_elements(
        xpath: "//div[contains(@class, 'hour_item_number')]"
      )
    if Rails.env.development?
      timeslots.first.click
    else
      timeslot = timeslots.select { |t| t.text == start_time }.first
      timeslot.click if timeslot
    end
    sleep(2)
    @driver.find_element(
      xpath: "//a[normalize-space(text())='Siguiente']"
    ).click
  end

  def select_court()
    puts "Selecting court..."
    @driver.find_element(
      xpath: "//button[normalize-space(text())='Seleccionar']"
    ).click
  end

  def add_players
    puts "Adding player..."
    @driver.find_element(
      xpath: "//button[normalize-space(text())='Agregar / Quitar jugadores']"
    ).click
    sleep(2)
    friends =
      @driver.find_elements(
        xpath: "//div[contains(@class, 'row mobileListItemV2 ng-scope')]"
      )
    puts "Agregando a #{friends[6].text}"
    friends[6].click
    @driver.find_element(
      xpath: "//button[normalize-space(text())='Seleccionar']"
    ).click
  end

  def complete_reservation
    @driver.find_element(
      xpath: "//button[contains(@class, 'reserva_btn_terceary')]"
    ).click
  end
end
