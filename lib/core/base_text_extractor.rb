class BaseTextExtractor < TextExtractor

  # This is called when text extraction has begun
  def starting_text_extraction
  end
  
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def html_text( text_node )
    self.remove_leading_and_trailing_whitespace( text_node )
  end

  # This is called when text extraction has finished
  def completed_text_extraction
  end
  
  protected
  
  def remove_leading_and_trailing_whitespace( text_node )
    to_return = []
    
    if( text_node.text_value =~ /^(\s+)/ )
      start_whitespace = $1
      to_return << HerbWhiteSpaceTextNode.new( start_whitespace )
    end

    to_return << HerbTextNode.new( text_node.text_value.strip )
    
    if( text_node.text_value =~ /(\s+)$/ )
      end_whitespace = $1
      to_return << HerbWhiteSpaceTextNode.new( end_whitespace )      
    end
    
    to_return
  end
  
end
