class String
  def __is_blank?
    !!(self =~ /\A[[:space:]]*\z/)
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
