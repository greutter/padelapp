# == Schema Information
#
# Table name: clubs
#
#  id                   :bigint           not null, primary key
#  address              :string
#  city                 :string
#  comuna               :string
#  google_maps_link     :string
#  latitude             :integer
#  longitude            :integer
#  members_only         :boolean
#  name                 :string
#  phone                :string
#  region               :string
#  third_party_software :string
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  third_party_id       :integer
#

#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Club < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :third_party_id,
            uniqueness: true,
            if: -> { third_party_software == "easycancha" }
  has_many :courts
  has_many :schedules
  has_many :availabilities

  def opens_at(date)
    if self.schedules.custom_default_for(date)
      custom_default = self.schedules.custom_default_for(date)
      date.beginning_of_day.change(
        { hour: custom_default.opens_at.hour, min: custom_default.opens_at.min }
      )
    else
      date.beginning_of_day.change(hour: Schedule::DEFAULTS[:opens_at])
    end
  end

  def closes_at(date)
    if false #self.schedules.custom_default_for(date)
      default = self.schedules.custom_default_for(date)
      date.beginning_of_day.in_time_zone.change(
        { hour: default.closes_at.hour, min: default.closes_at.min }
      )
    else
      date.beginning_of_day.in_time_zone.change(
        hour: Schedule::DEFAULTS[:closes_at]
      )
    end
  end

  def availability(date:, duration: 90, force_update: false, default_to: :any)
    date = date.to_date unless date.is_a? Date
    updated_availability =
      self.availabilities.updated_within_5_min.find_by(
        date: date,
        duration: duration
      )
    if updated_availability
      available_slots = updated_availability.slots
    else
      if third_party_software == "easycancha"
        available_slots = easycancha_available_slots(date, duration)
      elsif third_party_software == "tpc_matchpoint"
        available_slots = tpc_matchpoint_available_slots(date)
      else
        available_slots = reservio_available_slots(date, duration)
      end
      persist_available_slots(date, duration, available_slots)
    end

    if available_slots.nil? and default_to == :any
      available_slots =
        self
          .availabilities
          .where(date: date, duration: duration)
          .order(created_at: :desc)
          .last
    end
    return available_slots
  end

  def persist_available_slots(date, duration, available_slots)
    unless available_slots.nil?
      Availability.create(
        club_id: self.id,
        date: date,
        duration: duration,
        slots: available_slots
      )
    end
  end

  def reservio_available_slots(date, duration)
    available_slots = {}
    from = [opens_at(date), Time.now.round_off(30.minutes)].max
    to = closes_at(date) - duration.minutes
    (from.to_i...to.to_i)
      .step(30.minutes)
      .each do |time|
        starts_at = Time.at time
        # break if starts_at <= DateTime.now.in_time_zone - 15.minutes
        self.courts.each do |court|
          ends_at = starts_at + duration.minutes
          if court.is_slot_available?(starts_at: starts_at, ends_at: ends_at)
            # puts "{starts_at: #{starts_at}, ends_at: #{ends_at}, court_id: #{court.id}}"
            available_slots[starts_at] = {
              "starts_at" => starts_at,
              "duration" => duration,
              "ends_at" => ends_at,
              "courts" => [
                {
                  "id" => court.id,
                  "number" => court.number,
                  "price" => "to_be_defined"
                }.stringify_keys
              ]
            }.stringify_keys
            #falta modificar aquí para que devuelva todos los courts.
            break
          end
        end
      end
    return available_slots
  end

  def easycancha_available_slots(date, duration)
    EasycanchaBot.new.availability(
      club_id: self.id,
      date: date,
      duration: duration
    )
  end

  def tpc_matchpoint_available_slots(date)
    TpcBot.new(self).availability(date: date)
  end

  # def get_availabel_slots(date: , durations: [90])
  #   courts.first.get_availabel_slots(date: date, durations: durations)
  # end
end
