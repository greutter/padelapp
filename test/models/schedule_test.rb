# == Schema Information
#
# Table name: schedules
#
#  id          :bigint           not null, primary key
#  closes_at   :datetime
#  day_of_week :integer
#  opens_at    :datetime
#  tipo        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club_id     :integer
#
require "test_helper"

class ScheduleTest < ActiveSupport::TestCase

  test "Should return custom default schedule if any" do
    club = Club.first
    custom_default_schedule = club.schedules.custom_default_for_day(1)
    assert_instance_of Schedule, custom_default_schedule
    assert_equal Schedule.first, custom_default_schedule
  end

end
