class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show edit update destroy]

  def availability
    @club = Club.find(params[:club])
    @from_date =
      params[:from_date].blank? ? Date.today : Date.parse(params[:from_date])
    @selected_date =
      params[:from_date].blank? ? @from_date : Date.parse(params[:date])
  end

  # GET /reservations or /reservations.json
  def index
    @reservations = current_user.reservations.all.order(:starts_at)
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation =
      Reservation.new(
        starts_at: params[:starts_at],
        ends_at: params[:ends_at],
        court_id: params[:court_id]
      )
  end

  def pay
  end

  # GET /reservations/1/edit
  def edit
    @preference_data = {
      back_urls: {
        success: "#{request.host_with_port}/mp_payment_success",
        failure: "#{request.host_with_port}/mp_payment_failiure",
        pending: "http://localhost:3000/"
      },
      items: [
        {
          id: "#{@reservation.id}",
          category_id: "reservation",
          title:
            "Reserva Padel #{l(@reservation.starts_at, format: "%A %e %b %k:%M")}.",
          unit_price: @reservation.price,
          quantity: 1
        }
      ],
      payer: {
        email: "#{@reservation.user.email}"
      },
      binary_mode: true,
      external_reference: "Reservation/#{@reservation.id}"
    }
    sdk = Mercadopago::SDK.new(ENV["MERCADOPAGO_TEST_ACCESS_TOKEN"])
    preference_response = sdk.preference.create(@preference_data)
    @preference = preference_response[:response]
    # Este valor reemplazará el string "<%= @preference_id %>" en tu HTML
    @preference_id = @preference["id"]
    # @reservation.payments.create(preference_id: @preference_id, status: "pending")
  end

  # POST /reservations or /reservations.json
  def create
    if current_user
      user = current_user
    elsif User.find_by(email: params[:user][:email])
      user = User.find_by(email: params[:user][:email])
    else
      user =
        User.new(email: params[:user][:email], phone: params[:user][:phone])
      user.password = "1234"
      user.save(validate: false)
    end
    sign_in user
    @reservation = Reservation.new(reservation_params)
    @reservation.user = user

    respond_to do |format|
      if @reservation.save
        flash[:notice] = "Reserva creada pendiente de pago ;)"
        format.html { redirect_to edit_reservation_path @reservation }
        format.json { render :show, status: :created, location: @reservation }
      else
        flash[:alert] = @reservation.errors.full_messages.first
        format.html { redirect_to root_path }
        format.json do
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html do
          redirect_to reservation_url(@reservation),
                      notice: "Reservation was successfully updated."
        end
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html do
        redirect_to reservations_path, notice: "Cancelamos tu reserva. "
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reservation_params
    params.require(:reservation).permit(
      :user_id,
      :court_id,
      :starts_at,
      :ends_at
    )
  end
end
