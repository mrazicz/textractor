module Textractor
  class BlockFeatures
    module Counts
      def good_inline_count
        @good_inline_count ||= \
          element.css(Configuration.config.good_inline.join(', ')).size
      end

      def img_count
        @img_count ||= element.css('img').size
      end

      def pipe_char_count
        @pipe_char_count ||= @block.text.count('|')
      end

      def link_count
        # for main headlines return 0 always
        @link_count ||= @block.main_headline? ? 0 : element.css('a').size
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
        return @sentence_count if @sentence_count
        @sentence_count = if "#{@block.text} " =~ /[.?!][[:space:]]/
                            sentences.size
                          elsif @block.headline?
                            1
                          else
                            0
                          end
      end

      def long_word_count
        @long_word_count ||= words.count {|w| w.length > word_avg_length }
      end

      def short_word_count
        @long_word_count ||= words.count {|w| w.length < word_avg_length }
      end
    end
  end
end

