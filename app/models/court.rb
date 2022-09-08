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
end
