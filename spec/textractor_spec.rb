require 'spec_helper'

describe Textractor::App do
  before do
    @app = Textractor::App.new('http://google.com')
  end

  it "is example text" do
    "test".must_be_kind_of(String)
  end
end
