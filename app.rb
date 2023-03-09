require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'faye/websocket'

get '/' do
  erb :index
end