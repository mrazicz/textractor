# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: textractor 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "textractor"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Mrozek"]
  s.date = "2014-05-25"
  s.description = "Textractor - main text extraction from webpages"
  s.email = "mrazicz@gmail.com"
  s.executables = ["textractor"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.mdown"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Guardfile",
    "LICENSE.txt",
    "README.mdown",
    "Rakefile",
    "VERSION",
    "bin/textractor",
    "config.ru",
    "config/config.yml",
    "lib/server.rb",
    "lib/textractor.rb",
    "lib/textractor/analyser.rb",
    "lib/textractor/app.rb",
    "lib/textractor/block.rb",
    "lib/textractor/block_collection.rb",
    "lib/textractor/block_features.rb",
    "lib/textractor/block_features/averages.rb",
    "lib/textractor/block_features/counts.rb",
    "lib/textractor/block_features/densities.rb",
    "lib/textractor/block_features/nested_elements.rb",
    "lib/textractor/block_features/special_chars.rb",
    "lib/textractor/configuration.rb",
    "lib/textractor/http_client.rb",
    "lib/textractor/preprocessor.rb",
    "lib/train/train_utils.rb",
    "lib/utils.rb",
    "neurals/network.fann",
    "neurals/network1.fann",
    "public/master.css",
    "public/reset.css",
    "textractor.gemspec",
    "train_data/digest_file.txt",
    "train_data/train.txt",
    "training_pages/blesk.article.html",
    "training_pages/blog.filosof.a.html",
    "training_pages/blog.komart.a.html",
    "training_pages/blog.nic.a.1.html",
    "training_pages/blogs.technet.a.html",
    "training_pages/ct24.article.1.html",
    "training_pages/ct24.article.2.html",
    "training_pages/ct24.article.3.html",
    "training_pages/ctsport.article.1.html",
    "training_pages/denikreferendum.article.html",
    "training_pages/digiekonomika.a.html",
    "training_pages/digiekonomika.a1.html",
    "training_pages/g.cz.a.html",
    "training_pages/google.kokos.html",
    "training_pages/homepages/blesk.homepage.html",
    "training_pages/homepages/blog.filosof.hp.html",
    "training_pages/homepages/blog.nic.hp.html",
    "training_pages/homepages/blogs.technet.hp.html",
    "training_pages/homepages/csfd.hp.html",
    "training_pages/homepages/ct24.homepage.html",
    "training_pages/homepages/ct24.homepage.ukraine.html",
    "training_pages/homepages/denikreferendum.homepage.html",
    "training_pages/homepages/digiekonomika.hp.html",
    "training_pages/homepages/g.cz.hp.html",
    "training_pages/homepages/idnes.homepage.blog.html",
    "training_pages/homepages/index.homepage.html",
    "training_pages/homepages/itbiz.hp.html",
    "training_pages/homepages/lidovky.homepage.html",
    "training_pages/homepages/mozky.hp.html",
    "training_pages/homepages/msdenik.homepage.html",
    "training_pages/homepages/mywindows.hp.html",
    "training_pages/homepages/novinky.homepage.html",
    "training_pages/homepages/sbazar.hp.html",
    "training_pages/homepages/shop.alfa.hp.html",
    "training_pages/homepages/shop.alza.hp.html",
    "training_pages/homepages/sip.homepage.html",
    "training_pages/homepages/sport.homepage.html",
    "training_pages/homepages/super.homepage.html",
    "training_pages/homepages/zahradkar.hp.html",
    "training_pages/homepages/zive.hp.html",
    "training_pages/idnes.article.1.html",
    "training_pages/idnes.blog.article.html",
    "training_pages/indes.article.2.html",
    "training_pages/itbiz.a.1.html",
    "training_pages/jnm.a.html",
    "training_pages/klaboseni.nokia.html",
    "training_pages/lidovky.article.html",
    "training_pages/mozky.a.html",
    "training_pages/msdenik.article.html",
    "training_pages/mywindows.a.html",
    "training_pages/novinky.article.html",
    "training_pages/sbazar.a.html",
    "training_pages/shops/shop.alfa.p.html",
    "training_pages/shops/shop.alza.p.html",
    "training_pages/shops/shop.alza.ps.html",
    "training_pages/sip.article.html",
    "training_pages/sport.article.html",
    "training_pages/super.article.2.html",
    "training_pages/super.article.html",
    "training_pages/trailbusters.a.html",
    "training_pages/tyinternety.a.html",
    "training_pages/wiki.kokos.html",
    "training_pages/wiki.tcp.ip.html",
    "training_pages/zive.a.1.html",
    "training_pages/zive.a.2.html",
    "views/index.slim",
    "views/layout.slim"
  ]
  s.homepage = "http://github.com/mrazicz/textractor"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.4"
  s.summary = "Textractor - main text extraction from webpages"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_runtime_dependency(%q<curb>, ["~> 0.8"])
      s.add_runtime_dependency(%q<hashie>, ["~> 2.1.1"])
      s.add_runtime_dependency(%q<ruby-fann>, ["~> 1.2.6"])
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.4.5"])
      s.add_runtime_dependency(%q<rake>, ["~> 10.3.2"])
      s.add_runtime_dependency(%q<slim>, ["~> 2.0.2"])
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_development_dependency(%q<shotgun>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<guard-minitest>, [">= 0"])
      s.add_development_dependency(%q<growl>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_dependency(%q<curb>, ["~> 0.8"])
      s.add_dependency(%q<hashie>, ["~> 2.1.1"])
      s.add_dependency(%q<ruby-fann>, ["~> 1.2.6"])
      s.add_dependency(%q<sinatra>, ["~> 1.4.5"])
      s.add_dependency(%q<rake>, ["~> 10.3.2"])
      s.add_dependency(%q<slim>, ["~> 2.0.2"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_dependency(%q<shotgun>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<guard-minitest>, [">= 0"])
      s.add_dependency(%q<growl>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.6"])
    s.add_dependency(%q<curb>, ["~> 0.8"])
    s.add_dependency(%q<hashie>, ["~> 2.1.1"])
    s.add_dependency(%q<ruby-fann>, ["~> 1.2.6"])
    s.add_dependency(%q<sinatra>, ["~> 1.4.5"])
    s.add_dependency(%q<rake>, ["~> 10.3.2"])
    s.add_dependency(%q<slim>, ["~> 2.0.2"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<thor>, ["~> 0.19.1"])
    s.add_dependency(%q<shotgun>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<guard-minitest>, [">= 0"])
    s.add_dependency(%q<growl>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end

