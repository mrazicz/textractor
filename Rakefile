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

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "textractor"
  gem.homepage = "http://github.com/mrazicz/textractor"
  gem.license = "MIT"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "mrazicz@gmail.com"
  gem.authors = ["Daniel Mrozek"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

#require 'rcov/rcovtask'
#Rcov::RcovTask.new do |test|
  #test.libs << 'test'
  #test.pattern = 'test/**/test_*.rb'
  #test.verbose = true
  #test.rcov_opts << '--exclude "gems/*"'
#end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "textractor #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :console_pry do
  require 'pry'
  require 'pry/completion'
  require_relative './lib/textractor' # You know what to do.
  ARGV.clear
  Pry.start
end
task :c => :console_pry

