class HerbNodeRetainingTextNode < HerbNodeRetainingNode
  include TextNode

  def extract_text( text_extractor, node_tree )
    self.nodes.each do |node|
      node.extract_text( text_extractor, node_tree )
    end
  end
  
  def can_be_combined?
    true
  end
  
  def to_s
    @text_value
  end
  
  
end
