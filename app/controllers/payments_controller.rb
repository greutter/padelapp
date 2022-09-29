class PaymentsController < ApplicationController

  def instant_payment_notifications
    render json: {PadelApp: :ConTodo}.to_json, status: :ok
  end

  def mp_payment_success
    params.permit!
    hash_p  = params.to_h.except! :controller, :action

    payment = Payment.find_or_create_by(preference_id: params[:preference_id]) do |payment|

    end
    payment.update(hash_p)
    flash[:notice] = "Cancha lista ✔️. Ahora invita a los jugadores 👇🏼"
    redirect_to reservations_path
  end

  private
    def payment_params
      params.require(:payment).permit(:collection_id,
                                      :collection_status,
                                      :payment_id,
                                      :status,
                                      :external_reference,
                                      :payment_type,
                                      :merchant_order_id,
                                      :preference_id,
                                      :site_id,
                                      :processing_mode,
                                      :merchant_account_id)
    end
end
