Rails.application.routes.draw do

  devise_for :users 

  defaults format: :json do
    resources :sessions, only: [:create]

    resources :users do
      resources :transfers
    end
  end
end
