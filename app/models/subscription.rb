# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  email      :string
#  info       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Subscription < ApplicationRecord
  validates :email, presence: true
end
