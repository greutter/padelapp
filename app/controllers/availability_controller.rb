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
      (params[:from_date].blank? ? Date.today : Date.parse(params[:from_date]))
    @selected_date =
      params[:date].blank? ? @from_date : Date.parse(params[:date])
    @selected_date = Date.today if @selected_date < Date.today

    @duration = params[:duration].blank? ? 90 : params[:duration].to_i

    @availabilities =
      Availability.availabilities(
        date: @selected_date,
        clubs: @clubs,
        update: false
      )

    @updated_at =
      @availabilities
        .values
        .map { |availability| availability.created_at }
        .compact
        .min

    @time_ranges = {
      temprano: (5..8),
      durante_el_dia: (8.5..17.5),
      tarde: (18..24)
    }
    @params = request.parameters.merge
  end
end
