# == Schema Information
#
# Table name: schedules
#
#  id          :bigint           not null, primary key
#  closes_at   :datetime
#  day_of_week :integer
#  opens_at    :datetime
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  club_id     :integer
#
require "test_helper"

class ScheduleTest < ActiveSupport::TestCase

  
end
