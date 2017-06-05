Rails.application.routes.draw do  
  defaults format: :json do
    resources :sessions, only: [:create]

    resources :users do
      resources :transfers
    end
  end
end
