class ClubsController < ApplicationController
  before_action :set_club, only: %i[show edit update destroy]

  # GET /clubs or /clubs.json
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
        .order(:comuna, :name)
        .active
  end

  # GET /clubs/1 or /clubs/1.json
  def show
    @duration = 90
    @selected_date = params[:date]&.to_date || Date.today
    @from_date = params[:from_date]&.to_date || Date.today
    @availability =
      @club.availability date: @selected_date, updated_within: :if_old
    @params = request.parameters.merge
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs or /clubs.json
  def create
    @club = Club.new(club_params)

    respond_to do |format|
      if @club.save
        format.html do
          redirect_to club_url(@club), notice: "Club was successfully created."
        end
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1 or /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html do
          redirect_to club_url(@club), notice: "Club was successfully updated."
        end
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1 or /clubs/1.json
  def destroy
    @club.destroy

    respond_to do |format|
      format.html do
        redirect_to clubs_url, notice: "Club was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_club
    @club = Club.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def club_params
    params.require(:club).permit(:name, :address, :google_maps_link, :phone)
  end
end
