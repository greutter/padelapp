# == Schema Information
#
# Table name: clubs
#
#  id                   :bigint           not null, primary key
#  active               :boolean
#  address              :string
#  city                 :string
#  comuna               :string
#  email                :string
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
  include ActiveModel::AttributeMethods

  alias_attribute :tps, :third_party_software
  alias_attribute :tps_id, :third_party_id

  validates :name, presence: true, uniqueness: true
  has_many :courts, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :availabilities, dependent: :destroy

  scope :active, -> { where("active") }

  before_create :parse_phone
  before_update :parse_phone
  after_create :create_courts

  def create_courts
    TpcBot.new(self).create_courts if reservation_software == "tpc_matchpoint"
  end

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

  def demand_level(start_time)
    hour = start_time.hour + start_time.min
    case hour
    when (4...7)
      "low"
    when (7...9)
      "medium"
    when (9...18.5)
      "low"
    when (18.5...21)
      "high"
    when (21..24)
      "medium"
    end
  end

  def availability(date:, duration: 90, updated_within: :if_old)
    date = date.to_date unless date.is_a? Date
    if updated_within.is_a? ActiveSupport::Duration
      self
        .availabilities
        .updated_within(updated_within)
        .where(date: date, duration: duration)
        .last
    else
      case updated_within
      when :force_update
        return update_availability(date: date)
      when :if_old
        persisted_availability =
          self
            .availabilities
            .updated_within(availability_ttl)
            .where(date: date, duration: duration)
            .last
        if persisted_availability.present?
          return persisted_availability
        else
          return update_availability(date: date)
        end
      end
    end
  end

  def reservation_url
    case self.reservation_software
    when "easycancha"
      "https://www.easycancha.com/book/clubs/#{self.tps_id}/sports"
    when "tpc_matchpoint"
      self.website
    end
  end

  def availability_ttl
    case self.reservation_software
    when "easycancha"
      return 1200.minutes if Rails.env.development?
      15.minutes
    when "tpc_matchpoint"
      30.minutes
    else
      10.minutes
    end
  end

  def update_availability(date:, duration: 90)
    if reservation_software == "easycancha"
      available_slots = EasycanchaBot.new(self).availability(date)
    elsif reservation_software == "tpc_matchpoint"
      available_slots = TpcBot.new(self).availability(date)
    else
      available_slots = reservio_available_slots(date, duration)
    end
    return persist_available_slots(date, duration, available_slots)
  end

  def persist_available_slots(date, duration, available_slots)
    available_slots.select! { |k, v| v.present? }
    availability =
      Availability.create(
        club_id: self.id,
        date: date,
        duration: duration,
        slots: available_slots
      )
  end

  def reservation_software
    if read_attribute(:third_party_software)
      read_attribute(:third_party_software).sub /_\d/, ""
    end
  end

  def reservio_available_slots(date, duration)
    available_slots = {}
    from = [opens_at(date), Time.now.in_time_zone.round_off(30.minutes)].max
    to = closes_at(date) - duration.minutes
    (from.to_i...to.to_i)
      .step(30.minutes)
      .each do |time|
        starts_at = Time.at(time).in_time_zone
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

  def parse_phone
    self.phone = self.phone.delete(" ")
  end
end
