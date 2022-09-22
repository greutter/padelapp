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
class Court < ApplicationRecord
  belongs_to :club
  validates :number, uniqueness: {scope: :club}

  def availabel_slots(date: , duration: 90)
    starts_at = opens_at(date)
    ends_at = starts_at + duration.minutes
    as = []
    while ends_at < closes_at(date)
      ends_at = starts_at + duration.minutes
      as << [starts_at]
      starts_at = ends_at
    end
    return as
  end

  def opens_at(date)
    club.opens_at(date)
  end

  def closes_at(date)
    club.closes_at(date)
  end

end
