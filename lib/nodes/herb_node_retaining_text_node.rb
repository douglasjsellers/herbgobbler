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
      if( node.is_a?( MethodCallNode ) )
        node.extract_text( text_extractor, node_tree, self.nodes )
      else
        node.extract_text( text_extractor, node_tree )
      end
    end
  end

  def explode
    nested_level = nesting_level
    to_return = []
    current_nest = 0
    new_node_list = nil
    
    # Go through and try to build rolled up nodes for all of the node
    # contents that are below the nested list level
    nodes.each do |current_node|
      if( current_node.node_name == "html_start_tag" )
        current_nest += 1
        if( new_node_list.nil? )
          to_return << current_node
        else
          new_node_list << current_node
        end
        if( current_nest == nesting_level + 1 )
          new_node_list = []
        end
      elsif( current_node.node_name == "html_end_tag" )
        if( current_nest == nesting_level + 1 )          
          to_return << build_correct_node_retaining_node( new_node_list )
          to_return << current_node
          new_node_list = nil
        elsif( new_node_list.nil? )
          to_return << current_node
        else
          new_node_list << current_node
        end
        current_nest -= 1
      elsif( new_node_list.nil? )
        to_return << current_node
      elsif( !new_node_list.nil?)
        new_node_list << current_node
      end

    end
    to_return << build_correct_node_retaining_node( new_node_list ) unless new_node_list.nil?   
    
    return to_return
  end

  def build_correct_node_retaining_node( array_of_nodes )
    text_retaining_node = false
    array_of_nodes.each do |node|
      text_retaining_node = true if node.is_a?(TextNode) && node.contains_alpha_characters?
    end

    if( text_retaining_node )
      to_return = HerbNodeRetainingTextNode.new
      to_return.add_all( array_of_nodes )
    else
      to_return = HerbNodeRetainingNonTextNode.create_from_nodes( array_of_nodes )
    end

    to_return
  end
  
  def can_be_exploded?
    # it is possible that this node contains only non text nodes.  If
    # there is no text within this combined node then this should be uncombined
    contains_list_of_elements? || contains_only_non_text_and_non_method_nodes?
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
  
  def contains_only_non_text_and_non_method_nodes?
    found_text = false
    nodes.each do |current_node|
      found_text = true if current_node.is_a?( TextNode ) && !current_node.is_a?(MethodCallNode)
    end
    !found_text
  end

  def contains_list_of_elements?
    # Two cases, first there could be an outer element that wraps the
    # list, if this is true we want to strip it.
    # After the outer elements are stripped then we want to walk
    # through and find all of the top level elements - where a top
    # level element is defined as anything that isn't nested further.
    nested_level = nesting_level
    nested_nodes = nested_nodes_list
    to_return = true    
    nested_nodes[nested_level].each do |node_at_node_level|
      to_return = false if node_at_node_level.is_a?(TextNode)
    end

    return to_return
  end

  def nested_nodes_list
    nested_level = 0
    nested_nodes = [ [] ]
    nodes.each do |current_node|
      if( current_node.node_name == "html_start_tag" )
        nested_nodes[nested_level] << current_node
        nested_level += 1
        nested_nodes[ nested_level ] = [] if nested_nodes[nested_level].nil?
      elsif( current_node.node_name == "html_end_tag" )
        nested_level -= 1
        nested_nodes[ nested_level ] << current_node
      elsif( current_node.is_a?( TextNode ) && current_node.contains_alpha_characters? )
        nested_nodes[ nested_level ] << current_node
      end
    end

    return nested_nodes
  end
  
  def nesting_level
    nested_nodes = nested_nodes_list
    nested_level = 0
    while( nested_nodes[nested_level].size == 2 && nested_nodes[nested_level].first.node_name == "html_start_tag" && nested_nodes[nested_level].last.node_name == "html_end_tag" )
      nested_level += 1
    end

    return nested_level
  end
  
  
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
