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
class Reservation < ApplicationRecord

  require "date_time_extensions.rb"

  belongs_to :user
  validates :user, presence: true

  belongs_to :court
  validates :court, presence: true

  has_many :payments, as: :payable
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :ends_at, comparison: { greater_than: :starts_at }

  def club
    court.club
  end

  def duration
    ((ends_at - starts_at) / 60).to_i
  end

  def paid?
    self.payments.where(status: :approved).any?
  end

  def price
    price_for_30_min = {(0.0..8.5) => 4000, (8.0..17.0) => 3000, (17...24) => 5000}
    price = 0
    starts_at.decimal_hour.step(by: 0.5, to: ends_at.decimal_hour - 0.5) do |st|
      price += price_for_30_min.select {|h| h === st/1.0 }.values.first
    end
    return price
  end

end
