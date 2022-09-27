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


  test "should specify avilable slots" do

    court = Court.first
    date = Date.tomorrow
    # puts "slot_druation:"
    slot_duration = [60, 60].sample

    available_time = (court.closes_at(date) - court.opens_at(date)) / 60
    assert_equal (23 - 7) * 60,  available_time

    available_slots = court.get_availabel_slots(date: date, durations: [slot_duration])
    assert_instance_of Hash, available_slots

    # puts "available_slots:"
    # puts available_slots[slot_duration]
    assert_equal (available_time / 30).to_i + 1 - (slot_duration / 30),
                  available_slots[slot_duration].count

  end

  test "should identify if slot is available" do
    court = Court.first
    date = Date.tomorrow
    starts_at = court.opens_at(date) + 4.hours
    duration = [60, 90].sample

    reservation = Reservation.find_or_create_by(user: User.first,
                                                    starts_at: starts_at,
                                                    ends_at: starts_at + duration.minutes,
                                                    court: court)



    available_slots = court.get_availabel_slots(date: date, durations: [60, 90])

    puts "Slots 60 min"
    puts available_slots[60]
    # puts "Slots 90 min"
    # puts available_slots[90]
    puts reservation.inspect

    assert not(court.is_slot_available?(starts_at: reservation.starts_at, ends_at: reservation.ends_at, verbose: true)),
          "Slot should be blocked if any reservation starts at same time"
    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minutes, ends_at: reservation.ends_at, verbose: true)),
          "Slot should be blocked if any reservation ends at same time"
    assert not(court.is_slot_available?(starts_at: reservation.starts_at + 5.minutes, ends_at: reservation.ends_at + 10.minutes, verbose: true)),
          "Slot that starts inside any reservation should be blocked"

    assert court.is_slot_available?(starts_at: starts_at - duration.minutes, ends_at: starts_at, verbose: true),
          "Slot that ends at the same time that reservation starts should be available"

    assert not(court.is_slot_available?(starts_at: reservation.ends_at + 30.minutes, ends_at: reservation.ends_at + (30+60).minutes,verbose: true)),
          "Slot that starts less than 30 minutes after any reservation should be blocked"
    assert not(court.is_slot_available?(starts_at: reservation.starts_at - (60+30).minutes, ends_at: reservation.ends_at - (30).minutes,verbose: true)),
        "Slot that ends less than 30 minutes before reservation starts should be blocked"

    # assert not(court.is_slot_available?(starts_at))
    # assert not(court.is_slot_available?(starts_at: reservation.starts_at, ends_at: reservation.ends_at)),
    #       "Slot should be blocked if starts inside any reservation"

    # assert not(court.is_slot_available?(starts_at: reservation.starts_at + 30.minutes, duration: duration)), "Slot should be blocked if starts 30 minutes after a reservation"
    # assert court.is_slot_available?(starts_at: reservation.starts_at + duration, duration: duration)




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

  test "should block slots with reservations" do
    # court = Court.first
    # date = Date.tomorrow

  end


end
