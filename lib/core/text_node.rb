module TextNode 
  include BaseNode
  include NodeProcessing

  def extract_text( text_extractor, node_tree )
    if( self.is_a?( HerbNodeRetainingNode ) )
      self.nodes.each do |node|
          node.extract_text( text_extractor, node_tree )
      end
    else
      if( self.has_leading_or_trailing_whitespace? )
        self.remove_leading_and_trailing_whitespace.each do |node|
          node.extract_text( text_extractor, node_tree )
        end
      else
        text_extractor.add_html_text( self )
      end
    end
  end
  
  def html?
    true
  end
  
  def text?
    true
  end

  def white_space?
    false
  end
  
  def top_level?
    true
  end  

  def has_variables?
    false
  end

  def amount_of_ending_whitespace
    self.text_value.length - self.text_value.rstrip.length    
  end
  
  def amount_of_starting_whitespace
    self.text_value.length - self.text_value.lstrip.length    
  end
  
  def has_leading_or_trailing_whitespace?
    amount_of_ending_whitespace > 0 || amount_of_starting_whitespace > 0
  end
  
  # This probably won't work, because I want it to retain all of the
  # nodes.  Maybe we should run this after the text extraction
  # happens?  Nope, that won't work....
  def remove_leading_and_trailing_whitespace
    to_return = []
    if( self.text_value.strip.empty? ) # is this only whitespace
      to_return << HerbWhiteSpaceTextNode.new( self.text_value )
    else # otherwise it has some text
      if( amount_of_starting_whitespace > 0 )
        to_return << HerbWhiteSpaceTextNode.new( self.text_value[0..(amount_of_starting_whitespace - 1 )] )
      end
      to_return << HerbTextNode.new( self.text_value.strip )
      if( amount_of_ending_whitespace > 0 )
        to_return << HerbWhiteSpaceTextNode.new( self.text_value[(self.text_value.length - amount_of_ending_whitespace)..self.text_value.length ])
      end
    end

    to_return
  end
  
    
end
