require 'sinatra/base'

require_relative './textractor.rb'

module Textractor
  module Server
    class App < Sinatra::Base
      set :root, File.dirname(__FILE__)
      set :views, settings.root + '/../views'

      get '/reset.css' do
        content_type :css
        File.read("#{settings.root}/../public/reset.css")
      end

      get '/master.css' do
        content_type :css
        File.read("#{settings.root}/../public/master.css")
      end

      get '/' do
        slim :index
      end

      post '/' do
        url = params[:url]
        @blocks = Textractor::App.new(url).
                                  perform(post_analyse: params[:post_analyser])
        slim :index
      end
    end
  end
end
