module BaseNode
  @@keys = []
  @@hash = nil
  
  def shatter?
    false
  end
  
  def shattered_node_list( *nodes )
      nodes.reject {|terminal| terminal.nil? || terminal.text_value.empty? }
  end

  protected

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
