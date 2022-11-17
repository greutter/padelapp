class AvailabilityController < ApplicationController
  def index
    @region = "Metropolitana"
    @comunas = Comuna.where("region like ?", "%#{@region}%").order(:sector)
    @sectors = Comuna.sectors
    @selected_sectors = (params[:sectors] or ["Santiago Oriente"])
    selected_comunas =
      Comuna.where("sector IN (?)", @selected_sectors).map { |c| c.name }
    @clubs =
      Club
        .where("comuna IN (?)", selected_comunas)
        .where(members_only: nil)
        .order(:comuna).last(2)

    @from_date =
      params[:from_date].blank? ? Date.tomorrow : Date.parse(params[:from_date])
    @selected_date =
      params[:from_date].blank? ? @from_date : Date.parse(params[:date])
    
    
    # @availability = Availability.find_or_create_by(query))
  end
end
