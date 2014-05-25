module Textractor
  class Block
    attr_reader :text, :parent, :wrapper, :element, :position,
                :relative_position, :class_chain, :path
    attr_accessor :nn_score, :score

    GOOD_THRESHOLD      = 0.5   # threshold for good blocks
    NEAR_GOOD_THRESHOLD = 0.25  # threshold for near good blocks

    def initialize element, class_chain, blocks
      @element = element.dup
      # TODO: how to convert lists, tables, definition lists etc. to text
      @text    = element.text
      @parent  = element.parent.name
      @path    = element.path
      @wrapper = BLOCK_ELEMENTS.include?(element.name) ? \
        element.name : parent
      @class_chain = class_chain
      @blocks      = blocks
    end

    def nn_good?
      nn_score.to_f > GOOD_THRESHOLD
    end

    def nn_near_good?
      nn_score.to_f > NEAR_GOOD_THRESHOLD && nn_score.to_f <= GOOD_THRESHOLD
    end

    def nn_bad?
      !good?
    end

    def score
      (@score || @nn_score).to_f
    end

    def good?
      score.to_f > GOOD_THRESHOLD
    end

    def bad?
      score.to_f > NEAR_GOOD_THRESHOLD
    end

    def good!
      @score = GOOD_THRESHOLD + 0.01
    end

    def bad!
      @score = NEAR_GOOD_THRESHOLD - 0.01
    end

    def features
      @features ||= BlockFeatures.new(self)
    end

    def name
      element.name
    end

    def set_position pos, all_count
      @position = pos
      @relative_position = (pos / all_count.to_f).round(3)
    end

    def headline?
      !! (element.name =~ /^h\d$/i)
    end

    def main_headline?
      !! (element.name =~ /^h[12]$/i)
    end
    
    def list?
      element.name == 'li'
    end

    def paragraph?
      element.name == 'p'
    end

    def normalize_for_neural val
      val == 0 ? val : val < 1 ? val : 1.0 / val
    end

    def prev_block_neural_data
      rslt = position - 1 < 0 ? nil : @blocks[position - 1]
      rslt ? rslt.features_data : Array.new(26, 0.0)
    end

    def next_block_neural_data
      rslt = @blocks[position+1]
      rslt ? rslt.features_data : Array.new(26, 0.0)
    end

    def features_data
      @features_data = [
        features.letter_count,            # 0
        features.word_count,              # 1
        features.capitalized_word_count,  # 2
        features.uppercased_word_count,   # 3
        features.sentence_count,          # 4
        features.numbers_density,         # 5
        features.spaces_density,          # 6
        features.link_count,              # 7
        features.pipe_char_count,         # 8
        features.img_count,               # 9
        features.good_inline_count,       # 10
        features.copyright_char?.to_f,    # 11
        features.lt_gt_char?.to_f,        # 12
        features.word_avg_length,         # 13
        features.sentence_avg_length,     # 14
        features.img_density,             # 15
        features.pipe_char_density,       # 16
        features.link_density,            # 17
        features.uppercase_density,       # 18
        features.long_word_density,       # 19
        features.short_word_density,      # 20
        features.good_parent_class?.to_f, # 21
        main_headline?.to_f,              # 22
        paragraph?.to_f,                  # 23
        list?.to_f,                       # 24
        relative_position,                # 25
      ]
      @features_data.map! {|v| normalize_for_neural(v) }
      @features_data
    end

    def data_for_neural
      prev_block_neural_data + features_data + next_block_neural_data
      #@data_for_neural
    end
  end
end

