# frozen_string_literal: true
require 'json'
require 'httparty'
require 'sinatra'

# Test API Plugin
class Slapin < Sinatra::Application
  set :environment, :production

  config_file '../config/environments.yml'

  @headers = {
    'Content-Type' => @config['plugin']['api']['content_type']
    # 'Authorization' => @config['plugin']['api']['auth']
  }

  get '/endpoint' do
    raise 'missing user' unless params[:user]
    raise 'missing channel' unless params[:channel]
    raise 'missing type' unless params[:type]
    raise 'missing timestamp' unless params[:timestamp]
    raise 'missing command' unless params[:command]
    get(params[:user], params[:command]) if params[:command] =~ /get/
    save(params[:user], params[:command]) if params[:command] =~ /save/
    hello_world(params[:user], params[:command]) if params[:command] =~ /hello_world/
  end

  get '/info' do
    # Info about plugin
  end

  def get(user, command)
    HTTParty.get(@bot_url, headers: @headers)
  end

  def save(user, command)
  end

  def hello_world(user, command)
  end
end
