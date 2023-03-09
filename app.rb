require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'faye/websocket'

set :sockets, []

get '/' do
  erb :index
end

get '/websocket' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on :open do |event|
      settings.sockets << ws
    end

    ws.on :message do |event|
      ws.send(event.data)
    end

    ws.on :close do |event|
      ws = nil
    end

    ws.rack_response
  end
end
