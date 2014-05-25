require 'bundler'
Bundler.require :default
require 'sinatra/base'
require './lib/server'

run Textractor::Server::App.new
