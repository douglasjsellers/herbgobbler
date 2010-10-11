class HerbCombinedNode

  def initialize( node_a, node_b )
    @combined_nodes = [node_a, node_b]
  end

  def node_name
    "herb_combined_nodes"
  end

  def can_be_combined?
    true
  end

  def text?
    @combined_nodes.first.text? || @combined_nodes.last.text?
  end
  
  def text_value
    to_return = "";
    @combined_nodes.each do |node|
      to_return << node.text_value
    end
    to_return
  end

  def to_s
    self.text_value
  end
  
end
