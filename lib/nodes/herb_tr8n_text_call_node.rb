class HerbTr8nTextCallNode

  
  def initialize
    @text_values = []
  end

  def add_text( text_value_as_string )
    @text_values << text_value_as_string
  end
  
  def text_value
    to_return = '<%= tr( "'

    @text_values.each do |text_value|
      to_return += text_value
    end
    
    to_return += '" ) %>'

    to_return
  end
  
end

