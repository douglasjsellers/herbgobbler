class ErbFile

  include NodeProcessing
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
      elsif( combindable_node?( node ) && combindable_node?( last_combined_node ) )
        new_node = HerbNodeRetainingNonTextNode.new( last_combined_node )
        new_node << node
        combined_nodes << new_node
      elsif( !node.is_a?(TextNode)  && !last_combined_node.is_a?(TextNode) && !(last_combined_node.is_a?(BaseNode) && last_combined_node.can_be_combined? ) && !(node.is_a?(NonTextNode) && node.can_be_combined? ) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNodeRetainingNonTextNode )
      elsif( last_combined_node.is_a?(TextNode) && node.is_a?(TextNode) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNodeRetainingTextNode )
      elsif( combindable_node?( last_combined_node ) && node.is_a?(TextNode) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNodeRetainingTextNode )
      elsif( combindable_node?( node ) && last_combined_node.is_a?(TextNode))
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNodeRetainingTextNode )        
      elsif( node.is_a?(NonTextNode) && node.can_be_combined? && last_combined_node.is_a?(TextNode ) )
        combined_nodes << combine_two_nodes( last_combined_node, node, HerbNodeRetainingTextNode )
      else
        combined_nodes << last_combined_node
        combined_nodes << node
      end
    end
    remove_edge_tags_from_combined_text_nodes( unwind_list( combined_nodes ) )
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
      if( node.respond_to?(:text?) && node.text? )
        text_extractor.start_html_text
        node.extract_text( text_extractor, new_node_set )
        new_node_set += text_extractor.end_html_text
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

  def unwind_list( nodes )
    to_return = []
    nodes.each do |node|
      if( node.is_a?( HerbNodeRetainingTextNode ) )
        if( node.can_be_exploded? )
          to_return += node.nodes
        else
          to_return << node
        end
      else
        to_return << node
      end
    end

    return to_return
  end
  
  def remove_edge_tags_from_combined_text_nodes( nodes )
    node_count = nodes.size
    to_return = []

    nodes.each do |node|
      if( node.is_a?( HerbNodeRetainingTextNode ) )
        to_return += remove_edge_tags_from_combined_text_node( node )
      else
        to_return << node
      end
    end

    if( node_count != to_return.length )
      to_return = remove_edge_tags_from_combined_text_nodes( to_return )
    end

    return to_return
  end

  def remove_edge_tags_from_combined_text_node( node )
    if( node.can_remove_starting_or_ending_html_tags? )
      node.break_out_start_and_end_tags
    else
      [node]
    end
  end
  
  
  
  def combine_two_nodes( node_a, node_b, resulting_node_type )
    if node_a.class == resulting_node_type
      node_a << node_b
      node_a
    else
      new_node = resulting_node_type.new( node_a )
      new_node << node_b
      new_node
    end
  end
  

  def combindable_node?( node )
    node.is_a?( NonTextNode) && node.can_be_combined?
  end
    
  def ErbFile.parse( data_to_parse )
    Treetop.load( $ERB_GRAMMER_FILE )
    @parser = ERBGrammerParser.new
    ErbFile.new( @parser.parse( data_to_parse ) )
  end
  
end
