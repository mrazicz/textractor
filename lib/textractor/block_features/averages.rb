module Textractor
  class BlockFeatures
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
  end
end

