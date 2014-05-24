class String
  def __is_blank?
    !!(self.encode('UTF-8', invalid: :replace) =~ /\A[[:space:]]*\z/)
  end
end

class StringUtils
  def self.sentences string
    "#{string} ".split(/[.!?][[:space:]]/).
                 reject(&:__is_blank?).map {|w| w.gsub(/[[:space:]]/, " ").strip }
  end

  def self.words string
    string.split(/[[:space:]]+/).reject(&:__is_blank?).map(&:strip)
  end
end

# boolean to int or float
module BooleanToNum
  def to_i
    self ? 1 : 0
  end

  def to_f
    to_i.to_f
  end
end

# include module to true and false classes
class TrueClass; include BooleanToNum; end
class FalseClass; include BooleanToNum; end
