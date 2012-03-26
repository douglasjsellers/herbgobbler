class Tr8nTextExtractor < BaseTextExtractor


  def initialize
    @current_onde = nil
  end
  
  # This is called when text extraction has begun
  def starting_text_extraction
  end

  def add_html_text( text_node )
    @current_node.add_text( text_node.text_value )
  end

  def add_variable( variable_name, variable_value )
    puts "Adding variable: #{variable_name}=#{variable_value}"
  end

  def translate_text( text_node_to_translate )
    puts "Transate text: #{text_node_to_translate}"
  end
  
  def end_html_text
    to_return = @current_node
    @current_node = nil
    [to_return]
  end

  def start_html_text
    @current_node = HerbTr8nTextCallNode.new
  end
    
  def completed_text_extraction
  end

  def white_space( node )

  end

  def add_non_text( non_text_node )
    if( non_text_node.node_name == 'html_start_tag' )
      start_html_tag( non_text_node )
    elsif( non_text_node.node_name == 'html_end_tag' )
      end_html_tag( non_text_node )
    end
  end

  def start_html_tag( html_start_node )
    puts "Start tag: #{html_start_node.tag_name.text_value}"
  end
  
  def end_html_tag( html_start_node )
    puts "End tag: #{html_start_node.tag_name.text_value}"
  end
  
  
end
