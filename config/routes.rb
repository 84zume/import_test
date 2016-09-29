Rails.application.routes.draw do
  get 'wellcome/index'

#  root :to => 'products#index'
  root 'wellcome#index'
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'heartrate_search/index' => 'heartrate_search#index'
  get 'heartrate_search/index' => 'wellcome#index'
  post 'wellcome/upload_process' => 'wellcome#upload_process'
  post 'wellcome/index' => 'heartrate_search#index'
 devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks' }

end
