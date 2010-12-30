class HerbNodeRetainingNode

  def initialize( first_node = nil )
    @sub_nodes = []
    @sub_nodes << first_node unless first_node.nil?
  end
  
  def nodes
    to_return = []
    @sub_nodes.each do|node|
      if( node.is_a?( HerbNodeRetainingNode ) )
        to_return += node.nodes
      else
        to_return << node
      end
    end
    to_return
  end
  
  def <<(node)
    if( node.is_a?(Array) )
      @sub_nodes+= node
    else
      @sub_nodes << node
    end
    self
  end
  
  def text_value
    to_return = ""
    @sub_nodes.each do |node|
      to_return += node.text_value
    end
    to_return
  end
    
end
