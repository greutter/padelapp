class PagesController < ApplicationController
  def home
  end

  def privio
    # @timestamp = Time.now.strftime("%H-%M-%S_")
    # EasycanchaBot.reserve
  end

  def findcourt
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
        .order(:comuna)
        .first(3)

    @from_date =
      params[:from_date].blank? ? Date.tomorrow : Date.parse(params[:from_date])
    @selected_date =
      params[:from_date].blank? ? @from_date : Date.parse(params[:date])

    @availability =
      @clubs
        .map { |club| [club.id, club.availability(date: @selected_date)] }
        .to_h
  end
end
