module Textractor
  class BlockFeatures
    module SpecialChars
      def copyright_char?
        @copyright_char ||= @block.text.include?("\u00A9")
      end

      def pipe_char?
        @pipe_char ||= @block.text.include?('|')
      end

      def lt_gt_char?
        @lt_gt_char ||= !!(@block.text =~ /[\u003c\u003e]/)
      end
    end
  end
end

