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
    date = Date.today
    assert_instance_of Array, court.availabel_slots(date: date, duration: 90)
    available_time = (court.closes_at(date) - court.opens_at(date)) * 24 * 60
    assert_equal (23 - 7) * 60,  available_time
    # puts "opens:" + court.opens_at(date).to_s
    # puts "closes:" + court.closes_at(date).strftime("%h:%m")
    # puts court.availabel_slots(date: date, duration: 90)
    assert_equal (available_time / 90).to_i + 1, court.availabel_slots(date: date, duration: 90).count

  end
end
