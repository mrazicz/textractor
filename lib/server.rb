require 'sinatra/base'

require_relative './textractor.rb'

module Textractor
  module Server
    class App < Sinatra::Base
      set :root, File.dirname(__FILE__)
      set :views, settings.root + '/../views'
      set :public_folder, 'public'

      get '/' do
        slim :index
      end

      post '/' do
        url = params[:url]
        @blocks = Textractor::App.new(url).
                                  dbg(false, true, params[:post_analyser])
        slim :index
      end
    end
  end
end
