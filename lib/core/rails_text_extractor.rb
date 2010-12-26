class RailsTextExtractor < BaseTextExtractor
  attr_reader :translation_store
  
  def initialize( translation_store = RailsTranslationStore.new )
    @key_store = []
    @translation_store = translation_store
  end
  
  # This is called when text extraction has begun
  def starting_text_extraction
  end

  def start_html_text
  end

  def end_html_text
  end
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def add_html_text( text_node )
    to_return = []
    to_return << HerbErbTextCallNode.new( [text_node.text_value], @key_store, "t '.", "'", text_node.html? )
    @translation_store.add_translation( to_return.last.key_value, to_return.last.original_text )        
    to_return
  end


  # This is called when text extraction has finished
  def completed_text_extraction
  end
  
end
