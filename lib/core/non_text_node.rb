module NonTextNode 
  def text?
    false
  end
  
  def top_level?
    true
  end  

  def white_space?
    false
  end
  
end
