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
    if( text_node.text_value.strip.empty? ) # is this only whitespace
      to_return << HerbWhiteSpaceTextNode.new( text_node.text_value )
    else # otherwise it has some text

      amount_of_starting_whitespace = text_node.text_value.length - text_node.text_value.lstrip.length
      amount_of_ending_whitespace = text_node.text_value.length - text_node.text_value.rstrip.length
      if( amount_of_starting_whitespace > 0 )
        to_return << HerbWhiteSpaceTextNode.new( text_node.text_value[0..(amount_of_starting_whitespace - 1 )] )
      end
      to_return << HerbTextNode.new( text_node.text_value.strip )
      if( amount_of_ending_whitespace > 0 )
        to_return << HerbWhiteSpaceTextNode.new( text_node.text_value[(text_node.text_value.length - amount_of_ending_whitespace)..text_node.text_value.length ])
      end
    end

    to_return
  end
  
end
