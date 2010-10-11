# This is only meant to be a base class, please extend and implement
# the base methods if you want to do anything interesting
class TextExtractor

  # This is called when text extraction has begun
  def starting_text_extraction
    raise "Please implement me"
  end
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def html_text( text_node )
    raise "Please implement me"
  end
end
