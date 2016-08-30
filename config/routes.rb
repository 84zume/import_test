Rails.application.routes.draw do
  get 'wellcome/index'

#  root :to => 'products#index'
  root 'wellcome#index'
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

 devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks' }
end
