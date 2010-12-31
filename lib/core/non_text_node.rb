module NonTextNode
  include BaseNode
  def can_be_combined?
    false
  end

  def extract_text( text_extractor, node_tree )
    if( self.white_space? )
      text_extractor.white_space( self )
    else
      text_extractor.add_non_text( self ) unless self.contains_only_whitespace?
    end
    
  end

  def contains_only_whitespace?
    self.text_value.strip.length == 0
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
