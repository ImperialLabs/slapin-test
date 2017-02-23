# frozen_string_literal: true
require 'json'
require 'httparty'
require 'sinatra'

# Test API Plugin
class Slapin < Sinatra::Application
  set :environment, :production

  config_file 'environments.yml'
  config_file 'api.yml'

  @headers = {}

  def bot_url
    @bot_url = ENV['BOT_URL'] ? ENV['BOT_URL'] : settings.bot_url
  end

  get '/endpoint' do
    raise 'missing user' unless params[:user]
    raise 'missing channel' unless params[:channel]
    raise 'missing type' unless params[:type]
    raise 'missing timestamp' unless params[:timestamp]
    raise 'missing command' unless params[:command]
    get(params[:user], params[:command]) if params[:command] =~ /get/
    save(params[:user], params[:command]) if params[:command] =~ /save/
    hello_world(params[:user], params[:channel], params[:command]) if params[:command] =~ /hello_world/
  end

  get '/info' do
    # Info about plugin
  end

  def get(user, command)

    HTTParty.get(@bot_url, headers: @headers)
  end

  def save(user, command)
    HTTParty.post(@bot_url, headers: @headers, body: body)
  end

  def hello_world(user, command)
    HTTParty.post(@bot_url, headers: @headers, body: body)
  end
end
