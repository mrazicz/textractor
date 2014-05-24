module Textractor
  class Configuration
    # fetch environment as symbol, aliased as "env"
    def self.environment
      ENV['RACK_ENV'].to_sym
    end
    def self.env; environment; end # just alias

    # simple, but useful methods
    def self.development?; env == :development; end
    def self.production?;  env == :production;  end
    def self.test?;        env == :test;        end

    # load config, aliased also as "config"
    def self.load
      @config ||=
        Hashie::Mash.new(YAML.load_file(ROOT.join('..', 'config', 'config.yml')))
    end
    def self.config; self.load; end # just alias

    # fetch key from config or return default value
    def self.fetch key, default=nil
      config.has_key?(key) ? config[key] : default
    end
  end
end

