module TextNode
  include BaseNode
  
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
  
end
