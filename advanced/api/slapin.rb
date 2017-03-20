# frozen_string_literal: true
require 'json'
require 'httparty'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'

# Test API Plugin
class Slapin < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::ConfigFile

  set :environment, :production

  config_file 'environments.yml'
  config_file 'api.yml'

  @headers = {
    plugin: 'api',
    key: ''
  }

  @bot_url = ENV['BOT_URL'] ? ENV['BOT_URL'] : settings.bot_url

  post '/endpoint' do
    raise 'missing user' unless params[:chat][:user]
    raise 'missing channel' unless params[:chat][:channel]
    raise 'missing type' unless params[:chat][:type]
    raise 'missing timestamp' unless params[:chat][:timestamp]
    raise 'missing command' unless params[:command]
    @params = params
    @command = @params[:command]
    @text_array = @params[:chat][:text].split(' ')
    search if @command[0] == 'search'
    save if @command[0] == 'save'
    hello_world if @command[0] == 'hello'
  end

  get '/info' do
    {
      help:
        {
          search: 'Search info from brain, Search for all keys: `@bot api search` - Search specific key for value: `@bot api search $key`"',
          save: 'Save info into brain: `@bot api save $key $value`',
          hello: 'Hello World Command: `@bot api hello world` returns `Hello World!`'
        }
    }.to_json
  end

  def search
    response = @command[1] ? search_value : search_keys
    speak('Search Return', 'Search Return', response)
  end

  def search_keys
    HTTParty.get("http://#{@bot_url}/v1/query_hash", headers: @headers)
  end

  def search_value
    @headers[:key] = @command[1]
    HTTParty.get("http://#{@bot_url}/v1/query_key", headers: @headers)
  end

  def save
    body = {
      plugin: @text_array[1],
      key: @command[1],
      value: @command[2]
    }
    HTTParty.post("http://#{@bot_url}/v1/save", headers: @headers, body: body)
  end

  def hello_world
    HTTParty.post("http://#{@bot_url}/v1/speak", headers: @headers, body: {channel: @params[:chat][:channel], text: 'Hello World!'})
  end

  def speak(fallback, title, text)
    body = {
      channel: @params[:chat][:channel],
      attachments:
        {
          fallback: fallback,
          title: title,
          text: text
        }
    }
    HTTParty.post("http://#{@bot_url}/v1/attachment", headers: @headers, body: body)
  end
end
