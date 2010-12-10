class HerbTextNode
  include TextNode
  attr_accessor :text_value
  
  def initialize( text )
    @text_value = text
  end

  def can_be_combined?
    true
  end
  
  def to_s
    @text_value
  end
  
  
end
