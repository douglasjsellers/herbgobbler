# This is only meant to be a base class, please extend and implement
# the base methods if you want to do anything interesting
class TextExtractor

  # This is called when text extraction has begun
  def starting_text_extraction
    raise "Please implement me (start_text_extraction)"
  end

  def add_html_text( text_node )
    raise "Please implement me (add_html_text)"    
  end

  def add_variable( variable_name, variable_value )
    raise "Please implement me (add_variable)"    
  end

  def translate_text( text_node_to_translate )
    raise "Please impelement me (translate_text)"
  end
  
  def end_html_text
    raise "Please implement me (end_html_text)"
  end

  def start_html_text
    raise "Please implement me (start_html_text)"
  end

  def white_space( node )
    raise "Please implement me (white_space)"
  end
  
  def add_non_text( non_text_node )
    raise "Please implement me (add_non_text)"
  end
   
end
