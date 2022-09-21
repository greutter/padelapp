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
    @club = Club.all.sample
  end

  test "should default nicely on any given day" do
    date = DateTime.now - 25.years
    opens_at = @club.opens_at(date)
    assert_instance_of DateTime, opens_at, "Should have an opening hour for random day"
    assert_equal opens_at.hour, Schedule::DEFAULTS[:opens_at], "Should open at default hour"
    closes_at = @club.closes_at(date)
    assert_instance_of DateTime, closes_at, "Should have a closing hour for random day"
    assert_equal closes_at.hour, Schedule::DEFAULTS[:closes_at], "Should close at default hour"
  end

  test "should return club specific default opening hour if available" do
    custom_default_schedule = @club.schedules.default(1)

    assert_instance_of DateTime, custom_default_schedule.first

    # opens_at = @club.opens_at(date)
    # assert_equal opens_at, DateTime.new.change({hour: 9, minute: 30})
  end

end
