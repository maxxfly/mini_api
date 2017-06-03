Rails.application.routes.draw do
  defaults format: :json do
    resources :users do
      resources :transfers
    end
  end
end
