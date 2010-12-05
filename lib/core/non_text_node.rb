module NonTextNode
  include BaseNode
  def can_be_combined?
    false
  end
  
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
