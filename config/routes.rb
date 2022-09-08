Rails.application.routes.draw do
  resources :courts
  resources :clubs

  root "pages#home"
end
