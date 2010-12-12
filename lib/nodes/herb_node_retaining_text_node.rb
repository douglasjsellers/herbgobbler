class HerbNodeRetainingTextNode < HerbNodeRetainingNode
  include TextNode

  def can_be_combined?
    true
  end
  
  def to_s
    @text_value
  end
  
  
end
