class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @club = Club.first
    @date = Date.today
    @from_date = Date.today
  end

  # GET /reservations/1/edit
  def edit
    preference_data = {
      back_urls: {
        success: "#{request.host_with_port}/mp_payment_success",
        # failure: "http://localhost:3000/reservations/#{@reservation.id}/edit",
        pending: 'http://localhost:3000/'
      },
      items: [
        {
          title: "payable_id: #{@reservation.id}",
          unit_price: 25,
          quantity: 1
        }
      ]}
      sdk = Mercadopago::SDK.new(ENV['MERCADOPAGO_TEST_ACCESS_TOKEN'])
      preference_response = sdk.preference.create(preference_data)
      preference = preference_response[:response]
      # Este valor reemplazará el string "<%= @preference_id %>" en tu HTML
      @preference_id = preference['id']
      @reservation.payments.create(preference_id: @preference_id)
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def availability
    @club = Club.first
    @from_date = Date.parse(params[:from_date])
    @date = Date.parse(params[:date])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :court_id, :starts_at, :ends_at)
    end
end
