Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/request_otp', to: 'auth#request_otp'
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  post '/logout', to: 'auth#logout'
  post '/forgot_password', to: 'auth#forgot_password'
  post '/reset_password', to: 'auth#reset_password'


  resources :users, only: [:show, :update, :destroy]
  resources :items, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:create]
end
