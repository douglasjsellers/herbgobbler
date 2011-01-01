class HerbTextNode
  include TextNode
  attr_accessor :text_value
  
  def initialize( text, strip_whitespace = true )
    @text_value = text
    @strip_whitespace = strip_whitespace
  end

  def can_be_combined?
    true
  end

  def strip_whitespace?
    @strip_whitespace
  end
  
  def to_s
    @text_value
  end
  
  
end
