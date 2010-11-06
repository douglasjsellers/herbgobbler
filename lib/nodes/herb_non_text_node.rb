class HerbNonTextNode
  include NonTextNode
  attr_accessor :text_value
  def initialize( text )
    @text_value = text
  end

  def can_be_combined?
    false
  end

  def node_name
    "non_text_node"
  end
  
  def to_s
    @text_value
  end
  
  
end
