# == Route Map
#

Rails.application.routes.draw do
  resources :reservations do
    collection do
      get "availability"
    end
  end
  resources :schedules
  devise_for :users
  resources :courts
  resources :clubs

  root "pages#home"
end
