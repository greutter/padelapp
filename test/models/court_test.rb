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
  # test "the truth" do
  #   assert true
  # end
end
