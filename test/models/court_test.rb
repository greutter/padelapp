# == Schema Information
#
# Table name: courts
#
#  id         :bigint           not null, primary key
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  club_id    :integer
#
require "test_helper"

class CourtTest < ActiveSupport::TestCase

  test "should have scheduled available hours same as club" do
    assert_equal Club.first.courts.first.opens_at(Date.today), Club.first.opens_at(Date.today)
  end

  test "should identify if slot is available" do
    court = Court.first
    date = Date.tomorrow
    starts_at = court.opens_at(date) + 4.hours
    duration = [60].sample

    reservation = Reservation.find_or_create_by(user: User.first,
                                                    starts_at: starts_at,
                                                    ends_at: starts_at + duration.minutes,
                                                    court: court)

    available_slots = court.get_availabel_slots(date: date, durations: [60, 90])

    puts "Slots #{duration} min"
    puts reservation.inspect
    puts available_slots[duration]
    # puts "Slots 90 min"



    assert not(court.is_slot_available?(starts_at: reservation.starts_at, ends_at: reservation.ends_at + 105.hours, verbose: true)),
          "Slot should be blocked if any reservation starts at same time"

    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minutes, ends_at: reservation.ends_at, verbose: true)),
          "Slot should be blocked if any reservation ends at same time"

    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minutes, ends_at: reservation.ends_at + 105.minutes, verbose: true)),
          "Slot that starts inside any reservation should be blocked"

    assert court.is_slot_available?(starts_at: starts_at - duration.minutes, ends_at: starts_at, verbose: true),
          "Slot that ends at the same time that reservation starts should be available"

    assert not(court.is_slot_available?(starts_at: reservation.ends_at + 30.minutes, ends_at: reservation.ends_at + (30 + duration).minutes,verbose: true)),
          "Slot that starts less than 30 minutes after any reservation should be blocked"

    assert not(court.is_slot_available?(starts_at: reservation.starts_at - (60+30).minutes, ends_at: reservation.ends_at - (30).minutes, verbose: true)),
        "Slot that ends less than 30 minutes before reservation starts should be blocked"

    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minute, ends_at: reservation.ends_at + 105.minute, verbose: true)),
          "Slot should be blocked if starts inside any reservation"

    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 30.minutes, ends_at: reservation.ends_at + 105.minutes, verbose: true)),
          "Slot should be blocked if starts 30 minutes after a reservation"





    assert not(court.is_slot_available?(starts_at: reservation.starts_at - 5.minutes, ends_at: reservation.ends_at + 5.minutes, verbose: true)),
          "Slot contains a reservation should be blocked"

    assert court.is_slot_available?(starts_at: reservation.starts_at - 55.minutes, ends_at: reservation.starts_at, verbose: true),
          "Slot that starts inmediatly after a reservation should be available."

    assert court.is_slot_available?(starts_at: reservation.ends_at, ends_at: reservation.ends_at + 90.minutes, verbose: true),
          "Slot that starts inmediatly after a reservation should be available."

    puts "starts:at #{(reservation.starts_at + 5.minutes).strftime("%H:%M")}"
    puts "ends_at: #{(reservation.ends_at - 5.minutes).strftime("%H:%M")}"      
    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minutes, ends_at: reservation.ends_at - 5.minutes, verbose: true)),
          "Slot inside a reservation should be blocked"




    # slot_duration = [60, 90].sample
    #
    # available_slots = court.get_availabel_slots(date: date, durations: [slot_duration])
    # puts "available_slots:"
    # puts available_slots[slot_duration]
    #
    #
    # assert_equal court.opens_at(date) + slot_duration * 60,
    #             available_slots[0]

  end

end
