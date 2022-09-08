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
class Club < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :courts
end
