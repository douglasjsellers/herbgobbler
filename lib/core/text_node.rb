module TextNode 
  include BaseNode
  include NodeProcessing
  
  def html?
    true
  end
  
  def text?
    true
  end

  def white_space?
    false
  end
  
  def top_level?
    true
  end  

  def has_variables?
    false
  end
    
end
