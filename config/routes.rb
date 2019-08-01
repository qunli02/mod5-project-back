Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:index, :update, :create]
      resources :players, only: [:index, :update, :create]
      resources :characters, only: [:index, :update]
    end
  end
  mount ActionCable.server => '/cable'
end
