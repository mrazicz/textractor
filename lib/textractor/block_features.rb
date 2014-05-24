module Textractor
  class BlockFeatures
    include Counts
    include Averages
    include Densities
    include NestedElements
    include SpecialChars

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

    def good_parent_class?
      @good_parent_class ||=
        (@block.class_chain & Configuration.config.good_classes_and_ids).any?
    end

    private

    def element
      @block.element
    end
  end
end

