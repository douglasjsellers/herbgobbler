class HerbNodeRetainingNonTextNode < HerbNodeRetainingNode
  include NonTextNode

  def initialize( first_node = nil )
    super( first_node )
    @can_be_combined = false
  end

  def <<(node)
    super(node)
    @can_be_combined ||= ( node.respond_to?( :can_be_combined? ) && node.can_be_combined? )
  end

  def can_be_combined?
    @can_be_combined
  end

  def self.create_from_nodes( nodes )
    to_return = HerbNodeRetainingNonTextNode.new
    nodes.each do |node|
      to_return << node
    end
    to_return
  end
  
    
  
  
  
end
