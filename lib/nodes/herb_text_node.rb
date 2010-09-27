class HerbTextNode
  include TextNode
  attr_accessor :text_value
  def initialize( text )
    @text_value = text
  end
  
  def to_s
    @text_value
  end
  
  
end
