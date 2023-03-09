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
      settings.sockets.each do |socket|
        socket.send(event.data)
      end
    end

    ws.on :close do |event|
      ws = nil
      settings.sockets.delete(ws)
    end

    ws.rack_response
  end
end
