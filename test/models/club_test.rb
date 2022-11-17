# == Schema Information
#
# Table name: clubs
#
#  id                   :bigint           not null, primary key
#  address              :string
#  city                 :string
#  comuna               :string
#  google_maps_link     :string
#  latitude             :integer
#  longitude            :integer
#  members_only         :boolean
#  name                 :string
#  phone                :string
#  region               :string
#  third_party_software :string
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  third_party_id       :integer
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
    date = Date.new(2022, 10, 23) # Domingo .wday is 0.
    # assert_equal date.in_time_zone.change(hour: 9, min: 30),
    #              @club.opens_at(date),
    #              "Testing opens_at"

    assert_equal date.in_time_zone.change(hour: 20, min: 30),
                 @club.closes_at(date), "Testing closes_at"
  end
end
