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
        if is_slot_available?(starts_at: starts_at, ends_at: ends_at) and starts_at >= DateTime.now.in_time_zone - 15.minutes
          as << [starts_at]
        end
        starts_at = starts_at + 30.minutes
      end
        available_slots[duration] = as
      end
    return available_slots
  end

  def is_slot_available?(starts_at: , ends_at: , verbose:  false)
    if self.reservations.find_by("starts_at = ?", starts_at)
      print_verbose(starts_at, ends_at, "1 slot blocked because starts at same time as a reservation") if verbose
      return false
    elsif self.reservations.find_by("ends_at = ?", ends_at)
      print_verbose(starts_at, ends_at, "2 slot blocked because ends at same time as a reservation") if verbose
      return false
    elsif self.reservations.find_by(starts_at: (starts_at...ends_at))
      print_verbose(starts_at, ends_at, "3 slot blocked because a reservation starts inside the slot") if verbose
      return false
    elsif self.reservations.find_by(ends_at: ((starts_at + 0.1.minutes)..ends_at))
      print_verbose(starts_at, ends_at, "4 a reservation ends inside the slot") if verbose
      return false
    elsif self.reservations.find_by(ends_at: (starts_at - 30.minutes))
      print_verbose(starts_at, ends_at, "5 starts after 30 minutes of a reservation" ) if verbose
      return false
    end
    return true
  end

  def print_verbose(starts_at, ends_at, explanation)
    puts "strats at: #{starts_at.to_s}"
    puts "ends_at  : #{ends_at.to_s}"
    puts "blocked because it: #{explanation}"
    puts ""
  end

  def opens_at(date)
    club.opens_at(date)
  end

  def closes_at(date)
    club.closes_at(date)
  end

end
