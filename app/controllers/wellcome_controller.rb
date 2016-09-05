require 'faraday'
class WellcomeController < ApplicationController
  before_action :authenticate_user!  


  def index
    token = session[:fitbit_access_token]
    if token
      conn = Faraday.new(:url => 'https://api.fitbit.com') do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter
      end
            response = conn.get do |request|
        # Get messages from the inbox
        # Sort by DateTimeReceived in descending orderby
        # Get the first 20 results
        request.url '1/user/-/activities/heart/date/2016-09-01/1d.json'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
      end
 
      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      @messages = JSON.parse(response.body)['activities-heart-intraday']['dataset']
      p 'この下メッセージ'
      p JSON.parse(response.body)['value']
      p JSON.parse(response.body)['activities-heart-intraday']['dataset']
      p '0000'
      p JSON.parse(response.body)
    else
      redirect_to root_url
    end
  end
end
