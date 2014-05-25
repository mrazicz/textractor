# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

Bundler::GemHelper.install_tasks

task :console_pry do
  require 'pry'
  require 'pry/completion'
  require_relative './lib/textractor' # You know what to do.
  ARGV.clear
  Pry.start
end
task :c => :console_pry

