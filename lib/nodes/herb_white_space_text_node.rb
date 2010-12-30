class HerbWhiteSpaceTextNode < HerbTextNode

  def extract_text( text_extractor, node_tree )
    text_extractor.white_space( self )
  end
  
  def node_name
    "herb_white_space_text_node"
  end
  
  def white_space?
    true
  end
end
