class CourtsController < ApplicationController
  before_action :set_court, only: %i[ show edit update destroy ]

  # GET /courts or /courts.json
  def index
    @courts = Court.all
  end

  # GET /courts/1 or /courts/1.json
  def show
  end

  # GET /courts/new
  def new
    @court = Court.new
  end

  # GET /courts/1/edit
  def edit
  end

  # POST /courts or /courts.json
  def create
    @court = Court.new(court_params)

    respond_to do |format|
      if @court.save
        format.html { redirect_to court_url(@court), notice: "Court was successfully created." }
        format.json { render :show, status: :created, location: @court }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courts/1 or /courts/1.json
  def update
    respond_to do |format|
      if @court.update(court_params)
        format.html { redirect_to court_url(@court), notice: "Court was successfully updated." }
        format.json { render :show, status: :ok, location: @court }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courts/1 or /courts/1.json
  def destroy
    @court.destroy

    respond_to do |format|
      format.html { redirect_to courts_url, notice: "Court was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_court
      @court = Court.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def court_params
      params.require(:court).permit(:club_id, :number)
    end
end
