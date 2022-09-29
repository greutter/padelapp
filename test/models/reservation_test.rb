# == Schema Information
#
# Table name: reservations
#
#  id         :bigint           not null, primary key
#  ends_at    :datetime
#  starts_at  :datetime
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  court_id   :integer
#  user_id    :integer
#
require "test_helper"

class ReservationTest < ActiveSupport::TestCase

end
