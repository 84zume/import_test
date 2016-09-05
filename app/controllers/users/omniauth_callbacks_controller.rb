# class Users::OmniauthCallbacksController < ApplicationController
# end
# require 'fitgem'
require 'oauth2'
require 'base64'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
   def fitbit_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
        @user.update(fitbit_token: request.env["omniauth.auth"]["credentials"]["token"], fitbit_secret: request.env["omniauth.auth"]["credentials"]["secret"])
    @user.update(access_token: request.env["omniauth.auth"]["credentials"]["token"], refresh_token: request.env["omniauth.auth"]["credentials"]["refresh_token"], expires_at: request.env["omniauth.auth"]["credentials"]["expires_at"])     
    p @user    
    session[:fitbit_access_token] = @user.fitbit_token
    p session[:fitbit_access_token] 
    auth_hash = request.env["omniauth.auth"]
    access_token = auth_hash.credentials.token
#    client_id = '227S7Z'
#    client_secret = '8a0297c384667664b9ff6ecc3771bf54'
#    redirect_uri = 'http://localhost:3000/oauth2/callback'

# client = OAuth2::Client.new(client_id, client_secret,
#   site: 'https://api.fitbit.com',authorize_url: 'https://www.fitbit.com/oauth2/authorize', token_url: 'https://api.fitbit.com/oauth2/token')

# p client.auth_code.authorize_url(redirect_uri: redirect_uri, scope: 'heartrate')

# code = '6dc2185094561d56fed0269e7bb791aa711aef2e'
# bearer_token = "#{client_id}:#{client_secret}"
# encoded_bearer_token = Base64.strict_encode64(bearer_token)

# access_token = client.auth_code.get_token(code, grant_type: 'authorization_code', client_id: client_id, redirect_uri: redirect_uri, :headers => {'Authorization' => "Basic #{encoded_bearer_token}"})

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Fitbit"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.fitbit_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
