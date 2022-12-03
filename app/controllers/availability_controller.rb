class AvailabilityController < ApplicationController
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
        .where(members_only: nil)
        .order(:name)

    @from_date =
      params[:from_date].blank? ? Date.today : Date.parse(params[:from_date])
    @selected_date =
      params[:date].blank? ? @from_date : Date.parse(params[:date])
    @duration = params[:duration].blank? ? 90 : params[:duration].to_i

    @availabilities =
      Availability.availabilities(
        clubs: @clubs,
        date: @selected_date,
        default_to: :any
      )

    @updated_at =
      @clubs
        .map do |club|
          club.availabilities.where(date: @selected_date).maximum(:updated_at)
        end
        .min

      @params = request.parameters.merge
  end
end
