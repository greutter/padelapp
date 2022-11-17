# == Schema Information
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  query      :string
#  results    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
