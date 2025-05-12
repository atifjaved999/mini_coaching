require 'sidekiq/web'

Rails.application.routes.draw do

  get 'home/index'
  root "home#index"
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'signup'
        post 'login'
        post 'forgot_password'
        post 'reset_password'
        delete 'logout'
      end

      get 'client_sessions', to: 'sessions#client_sessions'
      get 'coach_sessions', to: 'sessions#coach_sessions'

      resources :users, only: [:index, :update, :destroy]
      resources :sessions do
        post :book, on: :collection
        get :available, on: :collection
        resources :session_users, only: [:index, :create, :destroy]
      end
    end
  end
end
