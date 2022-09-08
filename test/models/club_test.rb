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
  # test "the truth" do
  #   assert true
  # end
end
