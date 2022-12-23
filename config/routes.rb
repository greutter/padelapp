# == Route Map
#

Rails.application.routes.draw do
  get 'subscriptions/new'
  get 'subscriptions/create'
  authenticate :user do
    namespace :admin do
      # resources :schedules
      # resources :reservations
      # resources :payments
      # resources :courts
      # resources :comunas
      resources :clubs
      # resources :availabilities
      resources :users

      root to: "clubs#index"
    end
  end

  resources :clubs, only: %i[show index]

  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  resources :reservations do
    collection { get "availability" }
  end
  

  root "pages#home"
  get "debug" => "pages#debug"
  get "availability" => "availability#index"

  get "mp_payment_success" => "payments#mp_payment_success"
  get "mp_payment_failiure" => "payments#mp_payment_failiure"
  get "privacidad" => "pages#privacidad"

  get "privio" => "pages#privio"

end
