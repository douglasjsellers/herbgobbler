class HerbErbTextCallNode

  def initialize( text_values = [] )
    @text_values = text_values
  end

  def add_text( text )
    @text_values << text
  end

  def generate_key
  end
  
  def original_text
    @text_values.join( '' )
  end
  
  def text_value
    
  end
  
  def to_s
    text_value
  end
  
end
