require 'faraday'
require 'kconv'
class WellcomeController < ApplicationController
  before_action :authenticate_user!  


  def index
=begin
いったん削除
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
        request.url '1/user/-/activities/heart/date/2016-09-01/1d/1sec.json'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
      end
      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      @messages = JSON.parse(response.body)['activities-heart-intraday']['dataset']
      # JSONの中身見れる↓
      # p JSON.parse(response.body)['activities-heart-intraday']['dataset']
      @heartrates = '['
      @messages.each do |message|
        @heartrates = "#{@heartrates}[Date.UTC(2016,9,1,#{message['time'].to_s[0,2]},#{message['time'].to_s[3,2]},#{message['time'].to_s[6,2]}),#{message['value'].to_s}],"
      end
      @heartrates = "#{@heartrates.chop}]"
      @graph =  LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: '2016-09-01の心拍数の遷移')
        f.series(name: '心拍数',data: @heartrates,turboThreshold:5000)
      end

    else
      redirect_to root_url
    end
=end

  #アップロードファイルを取得
  @uploadedFile = Dir.glob("public/docs/*")
  end
  
  #もし、取り込み済みのものと名前がかぶったらエラーにしたければindexメソッド下部のようにファイル名取ってくる
  def upload_process
    #アップロードファイルを取得
    file = params[:upfile]
    #ファイルの名前を取得
    name = file.original_filename
    #許可する許可する拡張子を定義 (現段階でどのファイル形式かは決まってないので、コメントアウト)
  #  perms = ['.jpg','.jpeg']
   # if !perms.include?(File.extname(name).downcase)
   #   result = 'アップロードできるのは、。。。。ファイルのみです。'
   # elseif file.size > 1.megabyte
   #   result = '１MBまでです。'
  #  else
      name = name.kconv(Kconv::SJIS, Kconv::UTF8)
      #/public/docフォルダにファイル格納
      File.open("public/docs/#{name}", 'wb') { |f| f.write(file.read) }
      result = "#{name.toutf8}をアップロードしました。"
   # end
      render text: result
  end
end