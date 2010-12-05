module BaseNode
  def shatter?
    false
  end
  
  def shattered_node_list( *nodes )
      nodes.reject {|terminal| terminal.nil? || terminal.text_value.empty? }
  end
end
