# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textractor/version'

Gem::Specification.new do |spec|
  spec.name          = "textractor"
  spec.version       = Textractor::VERSION
  spec.authors       = ["Daniel Mrozek"]
  spec.email         = ["mrazicz@gmail.com"]
  spec.description   = %q{Textractor}
  spec.summary       = %q{Textractor}
  spec.homepage      = "https://github.com/mrazicz/textractor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<nokogiri>, ["~> 1.6"])
  spec.add_runtime_dependency(%q<curb>, ["~> 0.8"])
  spec.add_runtime_dependency(%q<hashie>, ["~> 2.1.1"])
  spec.add_runtime_dependency(%q<ruby-fann>, ["~> 1.2.6"])
  spec.add_runtime_dependency(%q<sinatra>, ["~> 1.4.5"])
  spec.add_runtime_dependency(%q<rake>, ["~> 10.3.2"])
  spec.add_runtime_dependency(%q<slim>, ["~> 2.0.2"])
  spec.add_runtime_dependency(%q<thin>, [">= 0"])
  spec.add_runtime_dependency(%q<thor>, ["~> 0.19.1"])
  spec.add_development_dependency(%q<shotgun>, [">= 0"])
  spec.add_development_dependency(%q<rdoc>, ["~> 3.12"])
  spec.add_development_dependency(%q<bundler>, ["~> 1.0"])
  spec.add_development_dependency(%q<jeweler>, ["~> 2.0.0"])
  spec.add_development_dependency(%q<simplecov>, [">= 0"])
  spec.add_development_dependency(%q<guard-minitest>, [">= 0"])
  spec.add_development_dependency(%q<growl>, [">= 0"])
  spec.add_development_dependency(%q<pry>, [">= 0"])
end
