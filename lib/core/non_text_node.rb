module NonTextNode
  include BaseNode
  def can_be_combined?
    false
  end

  def extract_text( text_extractor, node_tree )
    if( self.white_space? )
      text_extractor.white_space( self )
    else
      text_extractor.add_non_text( self )
    end
    
  end
  
  def text?
    false
  end
  
  def top_level?
    true
  end  

  def white_space?
    false
  end
  
end
