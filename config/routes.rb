require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
      post 'forgot_password', to: 'auth#forgot_password'
      post 'reset_password', to: 'auth#reset_password'
      delete 'logout', to: 'auth#logout'

      get 'sessions/client_sessions', to: 'sessions#client_sessions'
      get 'sessions/coach_sessions', to: 'sessions#coach_sessions'

      resources :sessions do
        post :book, on: :member
        get :available, on: :collection
        resources :session_users, only: [:index, :create, :destroy]
      end
    end
  end

end
