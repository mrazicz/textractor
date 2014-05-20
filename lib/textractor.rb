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
                      fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6
                      header hgroup hr noscript ol output p pre section table
                      thead tr td tfoot ul video li dir menu dt th caption col
                      colgroup tbody fieldset aside))
  INLINE_ELEMENTS = Set.new(%w(big i small tt s strike nobr font basefont blink
                      wbr abbr acronym cite code dfn em kbd strong samp var a
                      bdo br img map object q script span sub sup b button input 
                      label select textarea))

  ROOT = Pathname.new(File.dirname(__FILE__))

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
    attr_reader :text, :parent, :wrapper, :element, :position,
                :relative_position, :parent_chain

    def initialize element, parent_chain
      @element = element.dup
      # TODO: how to convert lists, tables, definition lists etc. to text
      @text    = element.text
      @parent  = element.parent.name
      @path    = element.path
      @wrapper = BLOCK_ELEMENTS.include?(element.name) ? \
        element.name : parent
      @parent_chain = parent_chain
    end

    def features
      @features ||= BlockFeatures.new(self)
    end

    def scores
      @scores ||= BlockScores.new()
    end

    def name
      element.name
    end

    def set_position pos, all_count
      @position = pos
      @relative_position = (pos / all_count.to_f).round(3)
    end

    def headline?
      element.name =~ /^h\d$/
    end
    
    def list?
      element.name == 'li'
    end

    def paragraph?
      element.name == 'p'
    end
  end

  # scores
  # ----------------------------------------------------------------------------
  class BlockScores
    attr_accessor :word_count, :sentence_count, :letter_count,
                  :capitalized_word_count, :uppercased_word_count,
                  :long_word_count, :short_word_count, :sentence_avg_length,
                  :word_avg_length, :link_density, :uppercased_density,
                  :long_word_density, :short_word_density, :total
  end

  # block features
  # ----------------------------------------------------------------------------
  class BlockFeatures
    module Counts
      def link_count
        @links_count ||= element.css('a').size
      end

      def word_count
        @word_count ||= words.size
      end

      def capitalized_word_count
        @capitalized_word_count ||= words.count {|w| w[0] =~ /\A[[:upper:]]/ }
      end

      def uppercased_word_count
        @uppercased_word_count ||= words.count {|w| w =~ /\A[[:upper:]]+\z/ }
      end

      def letter_count
        @letter_count ||= words.map(&:size).reduce(&:+)
      end

      def sentence_count
        @sentence_count ||= sentences.size
      end

      def long_word_count
        @long_word_count ||= words.count {|w| w.length > word_avg_length }
      end

      def short_word_count
        @long_word_count ||= words.count {|w| w.length < word_avg_length }
      end
    end

    module Averages
      def sentence_avg_length
        @sentence_avg_length ||= \
          sentences.map(&:size).reduce(&:+).to_f / sentence_count
      end

      # exclude links from average
      def word_avg_length
        return @word_avg_length if @word_avg_length
        words_to_count = words.reject {|w| w =~ /^(https?:\/\/|www\.)/i }
        @word_avg_length ||= \
          words_to_count.map(&:size).reduce(&:+).to_f / words_to_count.size
      end
    end

    # TODO: special chars dictionary and stopwords
    
    module Densities
      # TODO: densities for stopwords and special chars
      # TODO: densities for some inline elements

      def link_density
        @link_density ||= \
          links_as_words.map(&:size).reduce(&:+).to_f / word_count
      end

      def uppercase_density
        @uppercase_density ||= uppercased_word_count.to_f / word_count
      end

      def long_word_density
        @long_word_density ||= long_word_count.to_f / word_count
      end

      def short_word_density
        @long_word_density ||= short_word_count.to_f / word_count
      end
    end

    module NestedElements
      def nested_elements
        @nested_elements ||= @block.element.xpath('./*')
      end

      def nested_elements_names
        @nested_elements_names ||= Set.new(nested_elements.map(&:name))
      end

      def nested? element_name
        nested_elements_names.include?(element_name)
      end
    end
  end

  # block features
  # ----------------------------------------------------------------------------
  class BlockFeatures
    include Counts
    include Averages
    include Densities
    include NestedElements

    def initialize block
      @block = block
    end

    def sentences
      @sentences ||= StringUtils.sentences(@block.text)
    end

    def words
      @words ||= StringUtils.words(@block.text)
    end

    def links
      @links ||= @block.element.css('a')
    end

    def links_as_words
      @links_as_words ||= links.map {|e| StringUtils.words(e.text) }
    end

    private

    def element
      @block.element
    end
  end

  # array of blocks in same order as in document
  # ----------------------------------------------------------------------------
  class BlockCollection < Array
    attr_reader :title, :doc

    def initialize doc, title=nil
      super()
      @doc = doc
      @title = title
      convert(@doc)
    end

    def word_avg_count
      count_helper {|b| b.features.word_count }
    end

    def sentence_avg_count
      count_helper {|b| b.features.sentence_count }
    end

    def letter_avg_count
      count_helper {|b| b.features.letter_count }
    end

    def short_avg_count
      count_helper {|b| b.features.short_word_count }
    end

    def long_avg_count
      count_helper {|b| b.features.long_word_count }
    end

    private

    def count_helper
      self.map {|b| yield(b) }.reduce(&:+) / self.size
    end

    def convert doc, _parent_chain=[]
      parent_chain = _parent_chain
      doc.children.each do |el|
        parent = node_to_hash(el.parent)
        if _is_terminal_node?(el)
          self << Block.new(el, parent_chain + [parent])
        else
          convert(el, parent_chain + [parent])
        end
      end
    end

    # check if block element contains some other block elements
    def _is_terminal_node? el
      ! el.xpath('.//*').detect {|i| BLOCK_ELEMENTS.include?(i.name) }
    end

    def node_to_hash el
      {
        name:  el.name,
        class: el.xpath('./@class').text.split,
        id:    el.xpath('./@id').text.split,
      }
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

    def perform
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
      
      # create block collection
      rslt = BlockCollection.new(@doc, @page_info[:title])

      # clean block collection
      remove_blank_blocks!(rslt)
      convert_whitespaces!(rslt)

      # add position to block
      rslt.each_with_index {|b, i| b.set_position(i, rslt.size) }

      # return result
      rslt
    end

    private

    def get_title
      title = @doc.at_xpath('/html/head/title')
      @page_info[:title] = title && title.text
    end

    def remove_head
      # in fact, we don't removed head, just assigning body to @doc
      # if no body is present we trying to obtain something else or whole document
      @doc = @doc.at_xpath('/html/body') || @doc.at_xpath('//body') || @doc
    end

    def remove_tags tag
      @doc.search("//#{tag}").remove 
    end

    def convert_to_blocks
      @doc.traverse {|p| }
    end

    def remove_blank_blocks! data
      data.delete_if {|block| block.text.__is_blank? } 
    end

    def convert_whitespaces! data
      data.each do |block|
        block.text.gsub!(/([[:space:]])[[:space:]]{2,}/, "\\1")
        block.text.strip!
      end
    end
  end

  # page analyser
  # ----------------------------------------------------------------------------
  class Analyser
    attr_reader :blocks

    def initialize block_collection
      @blocks = block_collecion
    end

    def perform
      cfg = Configuration.config
      @blocks.map! do |block|
      end
    end
  end

  # config
  # ----------------------------------------------------------------------------
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

  # main
  # ----------------------------------------------------------------------------
  class App
    def initialize url
      @url = url
    end

    def run
      html_page = HTTPClient.new(@url).get.body
      rslt = Preprocessor.new(html_page).perform
      rslt.delete_if do |b|
        next false if rslt.word_avg_count <= b.features.word_count
        next false if b.list? && b.features.word_count > 6
        next false if b.paragraph? && b.features.link_density < 0.2
        next false if b.headline?
        true
      end
    end
  end
end


