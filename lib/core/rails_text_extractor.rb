class RailsTextExtractor < BaseTextExtractor
  
  # This is called when text extraction has begun
  def starting_text_extraction
    
  end
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def html_text( text_node )
    HerbErbTextCallNode.new( [super( text_node ).text_value], 't :' )
  end


  # This is called when text extraction has finished
  def completed_text_extraction

  end
  
end
