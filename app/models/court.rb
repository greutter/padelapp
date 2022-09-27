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
  has_many :reservations
  validates :number, uniqueness: {scope: :club}

  def get_availabel_slots(date: , durations: [90])
    available_slots = {}
    durations.each do |duration|
      starts_at = opens_at(date).in_time_zone
      ends_at = starts_at + duration.minutes
      as = []
      while ends_at < closes_at(date)
        ends_at = starts_at + duration.minutes
        if is_slot_available?(starts_at: starts_at, ends_at: ends_at) and starts_at >= DateTime.now.in_time_zone
          as << starts_at
        end
        starts_at = starts_at + 30.minutes
      end
        available_slots[duration] = as
      end
    return available_slots
  end

  def is_slot_available?(starts_at: , ends_at: , verbose:  false)

    if self.reservations.where("starts_at = ?", starts_at).any?
      print_verbose(starts_at, ends_at, 1)
      return false
    elsif self.reservations.where("ends_at = ?", ends_at).any?
      print_verbose(starts_at, ends_at, 2)
      return false
    elsif self.reservations.where(starts_at: (starts_at..ends_at - 0.1)).any?
      print_verbose(starts_at, ends_at, 3)
      return false
    elsif self.reservations.where(ends_at: ((starts_at + 0.1)..(ends_at - 0.1))).any?
      print_verbose(starts_at, ends_at, 4) if verbose
      return false
    elsif self.reservations.where(ends_at: (starts_at - 30.minutes)).any?
      print_verbose(starts_at, ends_at, 5) if verbose
      return false
    end

    return true
  end

  def print_verbose(starts_at, ends_at, id)
    puts "strats at: #{starts_at.to_s}"
    puts "ends_at  : #{ends_at.to_s}"
    puts "4"
  end

  def opens_at(date)
    club.opens_at(date)
  end

  def closes_at(date)
    club.closes_at(date)
  end

end
