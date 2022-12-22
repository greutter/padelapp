class AvailabilityController < ApplicationController
  # before_action :authenticate_user!

  def index
    @region = "Metropolitana"
    @sectors_names = Sector.all.map(&:name).uniq.reject(&:blank?)
    @comunas = Comuna.where("region like ?", "%#{@region}%").order(:sector)

    @selected_sectors_names =
      (params[:selected_sectors_names] or ["Santiago Oriente"])
    @selected_comunas = Comuna.where("sector IN (?)", @selected_sectors_names)

    @clubs =
      Club
        .where("comuna IN (?)", @selected_comunas.map(&:name))
        .order(:name)
        .active

    @from_date =
      if params[:from_date].blank?
        Time.now.in_time_zone.hour > 21 ? Date.tomorrow : Date.today
      else
        Date.parse(params[:from_date])
      end
    @selected_date =
      params[:date].blank? ? @from_date : Date.parse(params[:date])
    @duration = params[:duration].blank? ? 90 : params[:duration].to_i

    updated_within = Rails.env.production? ? 20.minutes : :if_old
    @availabilities =
      Availability.availabilities(
        date: @selected_date,
        clubs: @clubs,
        updated_within: updated_within
      )

    @updated_at =
      @availabilities
        .values
        .map { |availability| availability.created_at }
        .compact
        .min

    @params = request.parameters.merge
  end
end
