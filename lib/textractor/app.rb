module Textractor
  class App
    attr_reader :blocks

    def initialize url_or_file
      if url_or_file =~ /^https?:\/\/|^www\./ then @url = url_or_file
      else @filepath = url_or_file; end
    end

    def preprocess
      if @url then html_page = HTTPClient.new(@url).get.body
      else html_page = File.open(@filepath, 'rb').read; end
      @blocks = Preprocessor.new(html_page).perform
    end

    def analyse retrain=false
      Analyser.new(blocks).perform(retrain)
    end

    def post_analyse
      PostAnalyser.new(blocks).perform
    end

    def perform o={ post_analyse: true }
      preprocess
      analyse(o[:retrain])
      post_analyse if o[:post_analyse]
      @blocks
    end
  end
end

