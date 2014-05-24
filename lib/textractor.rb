require 'bundler'
require 'curb'
require 'nokogiri'
require 'yaml'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require_relative './utils'

module Textractor
  # TODO: li, dd, dt - really?
  BLOCK_ELEMENTS  = Set.new(%w(address article audio blockquote canvas dd div dl
                      fieldset footer form h1 h2 h3 h4 h5 h6
                      header hgroup hr noscript ol output p pre section table
                      thead tr td tfoot ul video li dir menu dt th caption col
                      colgroup tbody fieldset aside))
  # figure and figcaption are in fact block element but, here, for better 
  # preprocessing are like inline
  INLINE_ELEMENTS = Set.new(%w(big i small tt s strike nobr font basefont blink
                      wbr abbr acronym cite code dfn em kbd strong samp var a
                      bdo br img map object q script span sub sup b button input 
                      label select textarea figure figcaption))

  ROOT = Pathname.new(File.dirname(__FILE__))
end

Dir["#{File.dirname(__FILE__)}/textractor/**/*.rb"].each {|f| require f }
require_relative './train/train_utils'

