class SubscriptionsController < ApplicationController
  def new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save!
      session[:suscribed] = true
      redirect_to root_path,
                  notice:
                    "Listo 👍🏽. Gracias por permitirnos mantenerte al tanto."
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :user_id, :info)
  end
end
