Rails.application.routes.draw do
  devise_for :users
  resources :courts
  resources :clubs

  root "pages#home"
end
