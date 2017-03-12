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
    @params = params
    get if params[:command] =~ /get/
    save if params[:command] =~ /save/
    hello_world if params[:command] =~ /hello_world/
  end

  get '/info' do
    {
      help:
        get: "Get info from brain, Search for all keys: `@bot get` - Search specific key for value: `@bot get $key`"
        save: "Save info into brain: `@bot save $key $value`"
        hello: "Hello World Command: `@bot hello world` returns `Hello World!`"
    }.to_json
  end

  def get
    if @params[:command].include? ' '
      command_arrary = @params[:command].split(' ')
      return = get_value(command_arrary[1])
    else
      return = get_keys
    end
    speak('Search Return', 'Search Return', return)
  end

  def get_keys
    HTTParty.get(@bot_url + '/v1/query_hash', headers: @headers)
  end

  def get_value(key)
    text_array = @params[:text].split(' ')
    @headers['plugin'] = text_array[1]
    @headers['key'] = key
    HTTParty.get(@bot_url + '/v1/query_key', headers: @headers)
  end

  def save
    command_arrary = @params[:command].split(' ')
    HTTParty.post(@bot_url + '/v1/save', headers: @headers, body: body)
  end

  def hello_world
    HTTParty.post(@bot_url + '/v1/speak', headers: @headers, body: {channel: @params[:channel], text: 'Hello World!'})
  end

  def speak(fallback, title, text)
    body = {
      channel: @params[:channel],
      attachments:
        fallback: fallback,
        title: title,
        text: text
    }
    HTTParty.post(@bot_url + '/v1/attachment', headers: @headers, body: body)
  end
end
