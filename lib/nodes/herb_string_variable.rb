class HerbStringVariable < Treetop::Runtime::SyntaxNode
  include TextNode

  @@keys = []
  @@hash = nil
  
  def extract_text( text_extractor, node_tree )
    text_extractor.add_variable( I18nKey.new( self.variable.text_value, get_key_hash(text_extractor, node_tree) ).to_s , self.variable.text_value )    
  end

  private

  def get_key_hash( text_extractor, node_tree )
    # here we just try to use different keysets based on where they are in the tree since
    # there can only be key collisions when generating the same node
    if( @@hash != text_extractor.hash.to_s + node_tree.last.hash.to_s )
      @@keys = []
      @@hash = text_extractor.hash.to_s + node_tree.last.hash.to_s
    end
    @@keys
  end
  

  
  
end
