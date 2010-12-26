# This is only meant to be a base class, please extend and implement
# the base methods if you want to do anything interesting
class TextExtractor

  # This is called when text extraction has begun
  def starting_text_extraction
    raise "Please implement me"
  end

  def add_html_text( text_node )
    raise "Please implement me"    
  end

  def add_variable( variable_name, variable_value )
    raise "Please implement me"    
  end
  
  def end_html_text
    raise "Please implement me"
  end

  def start_html_text
    raise "Please implement me"
  end

  
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
