require 'bundler'
Bundler.setup :default
require 'sinatra/base'
require File.dirname(__FILE__) + "/lib/server"

run Textractor::Server::App.new
