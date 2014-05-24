module Textractor
  class HTTPClient
    def initialize url
      @url = url
    end

    def get
      _get
    end

    private

    def _get
      Curl.get(@url) do |http|
        http.follow_location = true
      end
    end
  end
end

