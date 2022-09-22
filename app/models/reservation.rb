# == Schema Information
#
# Table name: reservations
#
#  id         :bigint           not null, primary key
#  ends_at    :datetime
#  starts_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  court_id   :integer
#  user_id    :integer
#
class Reservation < ApplicationRecord
  belongs_to :user
  validates :user, presence: true

  belongs_to :court
  validates :court, presence: true
end
