require 'bundler/setup'
require 'curb'
require 'nokogiri'

module Textractor
  # TODO: li, dd, dt - really?
  BLOCK_ELEMENTS  = Set.new(%w(address article audio blockquote canvas dd div dl
                      fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6
                      header hgroup hr noscript ol output p pre section table
                      thead tr td tfoot ul video li dir menu dt th caption col
                      colgroup tbody fieldset aside))
  INLINE_ELEMENTS = Set.new(%w(big i small tt s strike nobr font basefont blink
                      wbr abbr acronym cite code dfn em kbd strong samp var a
                      bdo br img map object q script span sub sup b button input 
                      label select textarea))


  # http client
  # ----------------------------------------------------------------------------
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

  # base block
  # ----------------------------------------------------------------------------
  class Block
    attr_reader :text, :parent, :wrapper

    def initialize element
      @element = element.dup
      # TODO: how to convert lists, tables, definition lists etc. to text
      @text    = element.text
      @parent  = element.parent.name
      @path    = element.path
      @wrapper = BLOCK_ELEMENTS.include?(element.name) ? \
        element.name : parent
    end
  end

  # array of blocks in same order as in document
  # ----------------------------------------------------------------------------
  class BlockCollection < Array
    def initialize doc
      super()
      @doc = doc
      convert(@doc)
    end

    private

    def convert doc
      doc.children.each do |el|
        _is_terminal_node?(el) ? self << Block.new(el) : convert(el)
      end
    end

    # check if block element contains some other block elements
    def _is_terminal_node? el
      ! el.xpath('.//*').detect {|i| BLOCK_ELEMENTS.include?(i.name) }
    end
  end

  # page preprocessing
  # ----------------------------------------------------------------------------
  class Preprocessor
    def initialize html_page
      @html_page = html_page
      @doc       = Nokogiri::HTML(@html_page) 
      @orig_doc  = @doc
      @page_info = Hash.new
      @blocks    = Array.new
    end

    def preprocess
      get_title
      remove_head
      # TODO: remove more tags
      remove_tags(:script)
      remove_tags(:noscript)
      remove_tags(:object)
      remove_tags(:video)
      remove_tags(:style)
      remove_tags(:canvas)
      # TODO: get another pages and remove boilerplate, optional!!
      BlockCollection.new(@doc)
    end

    private

    def get_title
      title = @doc.at_xpath('/html/head/title')
      @page_info[:title] = title && title.text
    end

    def remove_head
      # in fact, we don't removed head, just assigning body to @doc
      @doc = @doc.xpath('/html/body')
    end

    def remove_tags tag
      @doc.search("//#{tag}").remove 
    end

    def convert_to_blocks
      @doc.traverse {|p| }
    end
  end

  # main
  # ----------------------------------------------------------------------------
  class App
    def initialize url
      @url = url
    end

    def run
      html_page = HTTPClient.new(@url).get.body
      Preprocessor.new(html_page).preprocess
    end
  end
end


