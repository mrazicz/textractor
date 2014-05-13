class String
  def blank?
    !!(self =~ /\A[[:space:]]*\z/)
  end
end
