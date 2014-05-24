module Textractor
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

    def convert doc, _class_chain=Set.new
      class_chain = _class_chain
      doc.children.each do |el|
        parent_ci = classes_and_ids(el.parent)
        if _terminal_node?(el)
          self << Block.new(el, class_chain + parent_ci)
        else
          convert(el, class_chain + parent_ci)
        end
      end
    end

    # check if block element contains some other block elements
    def _terminal_node? el
      ! el.xpath('.//*').detect {|i| BLOCK_ELEMENTS.include?(i.name) }
    end

    def classes_and_ids el
      el.xpath('./@*[name()="id" or name()="class"]').map(&:text).join(' ').split
    end
  end
end

