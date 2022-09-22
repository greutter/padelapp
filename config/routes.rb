Rails.application.routes.draw do
  resources :reservations
  resources :schedules
  devise_for :users
  resources :courts
  resources :clubs

  root "pages#home"
end
