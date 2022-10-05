# == Schema Information
#
# Table name: clubs
#
#  id               :bigint           not null, primary key
#  address          :string
#  google_maps_link :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "test_helper"

class ClubTest < ActiveSupport::TestCase
  def setup
    @club = Club.first
  end

  test "should default schedule nicely on any given date" do
    date = DateTime.now - 25.years
    opens_at = @club.opens_at(date)
    assert_equal opens_at.hour, Schedule::DEFAULTS[:opens_at]

    closes_at = @club.closes_at(date)
    assert_equal closes_at.hour, Schedule::DEFAULTS[:closes_at]
  end

  test "should default to custom default schedules if any" do
    custom_default_schedule = @club.schedules.custom_default_for_day(1)
    assert_equal Schedule.first.opens_at.to_datetime, custom_default_schedule.opens_at.to_datetime

    # opens_at = @club.opens_at(date)
    # assert_equal opens_at, DateTime.new.change({hour: 9, minute: 30})
  end

  test "should show correct availability for days with no reservation" do
    date = Date.today + 120.days
    puts @club.availability date: date

  end

  test "should "

end
