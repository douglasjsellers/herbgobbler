class ErbFile
  
  attr_accessor :nodes
  attr_accessor :node_set
  
  def initialize( node_set )
    @node_set = node_set
    @nodes = flatten_elements if compiled?
    @debug = false
  end

  def flatten_elements
    terminals = []
    flatten( @node_set, terminals )
    terminals
  end

  def compiled?
    !@node_set.nil?
  end

  def ErbFile.debug( file_path )
    ErbFile.parse( File.read( file_path ) )
    @parser.failure_reason
  end

  def combine_nodes( leaves )
    combined_nodes = []  
    leaves.each do |node|
      last_combined_node = combined_nodes.pop
      if( last_combined_node.nil? )
        combined_nodes << node
      elsif( !node.is_a?(TextNode)  && !last_combined_node.is_a?(TextNode) && !(node.is_a?(NonTextNode) && node.can_be_combined? ) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNonTextNode )
      elsif( last_combined_node.is_a?(TextNode) && node.is_a?(TextNode) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbTextNode )
      elsif( last_combined_node.is_a?(NonTextNode) && last_combined_node.can_be_combined? && node.is_a?(TextNode) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbTextNode )
      elsif( node.is_a?(NonTextNode) && node.can_be_combined? && last_combined_node.is_a?(TextNode ) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbTextNode )
      else
        combined_nodes << last_combined_node
        combined_nodes << node
      end
    end
    combined_nodes
  end
  

  def extract_text( text_extractor )
    # 1.  Going to have to loop over all of the elements and find all of
    # the text.
    # 2.  Then make the call back to the text_extractor
    # 3.  Finally replace the nodes in the top levels (not sure how
    # this is going to work with any of the nested stuff)
    text_extractor.starting_text_extraction
    new_node_set = []
    @nodes = combine_nodes( @nodes )    
    @nodes.each do |node|      
      if( node.text? )
        returned_nodes = text_extractor.html_text( node )
        new_node_set += returned_nodes unless returned_nodes.nil?
      else
        new_node_set << node
      end
      @nodes = new_node_set
      self
    end
    text_extractor.completed_text_extraction
  end
  
  def ErbFile.from_string( string_to_parse )
    ErbFile.parse( string_to_parse )
  end
  
  def ErbFile.load( file_path )
    ErbFile.parse( File.read( file_path ) )
  end

  def serialize
    to_return = ""
    nodes.each do |node|
      to_return << node.text_value
    end

    to_return
  end
  
  
  def to_s
    to_return = ""
    nodes.each do |node|
      to_return += node.text_value
    end
    to_return
  end
  
  private

  def combine_two_nodes( node_a, node_b, resulting_node_type )
    resulting_node_type.new( node_a.text_value + node_b.text_value )
  end
  
    
  def flatten(node, leaves = [])
    # This finds all of the leaves, where a leaf is defined as an
    # element with no sub elements.  This also treats combindable nodes
    # and text nodes as leaves because we want to keep them intact for
    # extraction and combination
    if( !node.respond_to?( :elements) ||
        node.elements.nil? ||
        node.elements.empty? ||
        node.is_a?( TextNode ) ||
        ( node.is_a?(NonTextNode) && node.can_be_combined? ) )
      leaves << node if( !node.text_value.empty? )
      leaves
    else
      node.elements.each do |sub_node|
        flatten( sub_node, leaves )
      end
      leaves    
    end
  end
  
  def ErbFile.parse( data_to_parse )
    Treetop.load( $ERB_GRAMMER_FILE )
    @parser = ERBGrammerParser.new
    ErbFile.new( @parser.parse( data_to_parse ) )
  end
  
end
