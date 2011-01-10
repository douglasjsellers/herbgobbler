class HerbNodeRetainingTextNode < HerbNodeRetainingNode
  include TextNode

  def add_all( nodes )
    nodes.each do |node|
      self << node
    end
  end
  
  def can_remove_starting_or_ending_html_tags?
    if( find_first_non_whitespace_node.node_name == "html_start_tag" && find_last_non_whitespace_node.node_name == "html_end_tag"  )
      if( find_first_non_whitespace_node.tag_name.text_value == find_last_non_whitespace_node.tag_name.text_value )
        true
      else
        false
      end
    elsif( find_last_non_whitespace_node.node_name == "html_start_tag" || find_first_non_whitespace_node.node_name == "html_end_tag" )
      true
    else
      false
    end
    
  end

  def break_out_start_and_end_tags
    if( find_first_non_whitespace_node.node_name == "html_start_tag" && find_last_non_whitespace_node.node_name == "html_end_tag"  )
( can_remove_starting_or_ending_html_tags? )
      start_tag = extract_leading_tag
      end_tag = extract_trailing_tag
      middle_tag = HerbNodeRetainingTextNode.new
      middle_tag.add_all( nodes[start_tag.nodes.length..nodes.length - (end_tag.nodes.length + 1 ) ] )
      [start_tag, middle_tag, end_tag]
    elsif(find_last_non_whitespace_node.node_name == "html_start_tag")
      end_tag = extract_trailing_tag
      start_tag = HerbNodeRetainingTextNode.new
      start_tag.add_all( nodes[0..nodes.length - (end_tag.nodes.length + 1 ) ] )
      [start_tag, end_tag]
    elsif(find_first_non_whitespace_node.node_name == "html_end_tag" )
      start_tag = extract_leading_tag
      end_tag = HerbNodeRetainingTextNode.new
      end_tag.add_all( nodes[start_tag.nodes.length..nodes.length ] )
      [start_tag, end_tag]
    else
      [self]
    end
  end
  
  
  def extract_text( text_extractor, node_tree )
    self.nodes.each do |node|
      node.extract_text( text_extractor, node_tree )
    end
  end
  
  def can_be_combined?
    true
  end
  
  def to_s
    @text_value
  end  
  
  def find_first_non_whitespace_node
    nodes.each do |node|
      return node unless node.text_value.strip.empty?
    end
  end

  def find_last_non_whitespace_node
    nodes.reverse.each do |node|
      return node unless node.text_value.strip.empty?
    end
  end


  private

  def extract_leading_tag
    node = find_first_non_whitespace_node
    to_return = []
    nodes.each do |current_node|
      to_return << current_node
      if( node == current_node )
        return HerbNodeRetainingNonTextNode.create_from_nodes( to_return )
      end
    end
  end

  def extract_trailing_tag
    node = find_last_non_whitespace_node
    to_return = []
    nodes.reverse.each do |current_node|
      to_return << current_node
      if( node == current_node )
        return HerbNodeRetainingNonTextNode.create_from_nodes( to_return.reverse )
      end
    end
    
  end
  
  
end
