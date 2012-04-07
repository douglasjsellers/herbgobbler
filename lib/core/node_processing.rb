module NodeProcessing

  
  def flatten(node, leaves = [])
    # This finds all of the leaves, where a leaf is defined as an
    # element with no sub elements.  This also treats combindable nodes
    # and text nodes as leaves because we want to keep them intact for
    # extraction and combination
    if( !node.respond_to?( :elements) ||
        node.elements.nil? ||
        node.elements.empty? ||
        (node.is_a?( TextNode ) && !node.has_variables?)||
        node.is_a?( HerbStringVariable ) ||
        node.is_a?( PluralizeNode ) || 
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

  
end
