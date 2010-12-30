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
  
  
  
end
