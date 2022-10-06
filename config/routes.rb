# == Route Map
#

Rails.application.routes.draw do

  resources :schedules
  resources :courts
  resources :clubs

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :reservations, only: [:new, :create] do
    collection do
      get "availability"
    end
  end


  authenticate :user do
    resources :reservations, only: [:show, :edit, :update, :destroy, :index]
  end

  root "pages#home"

  get 'mp_payment_success' => "payments#mp_payment_success"
  post '/ipn' => 'payments#instant_payment_notifications'
end
