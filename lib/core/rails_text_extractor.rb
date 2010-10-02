class RailsTextExtractor < BaseTextExtractor
  
  # This is called when text extraction has begun
  def starting_text_extraction
    
  end
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def html_text( text_node )
    to_return = []
    super(text_node).each do |text_node|
      if( text_node.white_space? )
        to_return << text_node
      else
        to_return << HerbErbTextCallNode.new( [text_node.text_value], 't :' )
      end
    end
    to_return
  end


  # This is called when text extraction has finished
  def completed_text_extraction

  end
  
end
