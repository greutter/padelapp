# == Schema Information
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  date       :string
#  duration   :integer
#  slots      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  club_id    :string
#
require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase

  def setup
    @clubs = Club.first(2)
    @date = Date.tomorrow
    @availbilities = Availability.availabilities(date: @date, clubs: @clubs)
  end

  test "each availability should contain club id as key" do
    assert_equal(@availbilities.map{|a| a.keys}.flatten, @clubs.map{|c| c.id})
  end

end
