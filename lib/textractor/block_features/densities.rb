module Textractor
  class BlockFeatures
    module Densities
      # TODO: densities for stopwords and special chars
      
      def img_density
        @img_density ||= img_count / word_count
      end

      def pipe_char_density
        @pipe_char_density ||= pipe_char_count / word_count
      end

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
        @short_word_density ||= short_word_count.to_f / word_count
      end

      def spaces_density
        @spaces_density ||= @block.text.scan(/\s/).size / letter_count
      end

      def numbers_density
        @numbers_density ||= @block.text.scan(/\d/).size / letter_count
      end
    end
  end
end

