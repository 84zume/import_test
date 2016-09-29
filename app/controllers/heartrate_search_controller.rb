require 'faraday'
class HeartrateSearchController < ApplicationController
    
     before_action :authenticate_user!  


  def index
    token = session[:fitbit_access_token]
    @inputDate = params[:inputDate]
    if token && params[:inputDate].present?
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
        request.url '1/user/-/activities/heart/date/' + params[:inputDate] + '/1d/1sec.json'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
      end
      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      if @messages.present?
        @messages = JSON.parse(response.body)['activities-heart-intraday']['dataset']
        # JSONの中身見れる↓
        # p JSON.parse(response.body)['activities-heart-intraday']['dataset']
        @heartrates = '['
        @messages.each do |message|
          @heartrates = "#{@heartrates}[Date.UTC(2016,9,1,#{message['time'].to_s[0,2]},#{message['time'].to_s[3,2]},#{message['time'].to_s[6,2]}),#{message['value'].to_s}],"
        end
        @heartrates = "#{@heartrates.chop}]"
#      @graph =  LazyHighCharts::HighChart.new('graph') do |f|
#        f.title(text: '2016-09-01の心拍数の遷移')
#        f.series(name: '心拍数',data: @heartrates,turboThreshold:5000)
#      end
      end

    else
      redirect_to root_url
    end
  end
end