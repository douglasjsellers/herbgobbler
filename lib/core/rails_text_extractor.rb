class RailsTextExtractor < BaseTextExtractor
  attr_reader :translation_store
  
  def initialize( translation_store = RailsTranslationStore.new )
    @key_store = []
    @translation_store = translation_store
    @current_text = []
    @current_nodes = []
  end
  
  # This is called when text extraction has begun
  def starting_text_extraction
  end

  def start_html_text
    @current_text = []
    @current_nodes = []
  end

  def end_html_text
    whitespace, @current_text = strip_ending_whitespace_nodes( @current_text )
    total_text = @current_text.inject("") { |all_text, node| all_text + node.text_value }
    @current_nodes << HerbErbTextCallNode.new( [total_text], @key_store, "t '.", "'" )
    @translation_store.add_translation( @current_nodes.last.key_value, @current_nodes.last.original_text )
    # Just reset everything here to be cautious
    to_return = @current_nodes
    @current_nodes = []
    @current_text = []
    return to_return + whitespace
  end

  def white_space( node )
    if( @current_text.empty? )
      @current_nodes << node
    else
      @current_text << node
    end
  end
  
  # This takes in a text node and returns one or more nodes that will
  # then be output.  The nodes that are output should implement
  # node_name and text_value
  def add_html_text( text_node )
    @current_text << text_node
  end

  
  def add_non_text( non_text_node )
    @current_text << non_text_node
  end
  
  # This is called when text extraction has finished
  def completed_text_extraction
  end

  protected

  def strip_ending_whitespace_nodes( node_list )
    whitespace = []
    while( !node_list.empty? && node_list.last.white_space? )
      whitespace << node_list.pop
    end
    return whitespace, node_list
  end
  
end
