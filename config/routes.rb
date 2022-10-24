# == Route Map
#

Rails.application.routes.draw do
  resources :schedules
  resources :courts
  resources :clubs

  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  resources :reservations, only: %i[new create] do
    collection { get "availability" }
  end

  authenticate :user do
    resources :reservations, only: %i[show edit update destroy index]
  end

  root "pages#home"

  get "mp_payment_success" => "payments#mp_payment_success"
  get "mp_payment_failiure" => "payments#mp_payment_failiure"

  get "privio" => "pages#privio"
end
