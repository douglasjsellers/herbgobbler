class HerbErbTr8nTextCallNode < HerbTr8nTextCallNode

  def add_text( text_value_as_string )
    mark_as_called_and_push_whitespace
    super( text_value_as_string )
  end

  def add_variable( name, value )
    mark_as_called_and_push_whitespace
    super( name, value )
  end

  def add_pluralization( variable_name, singular, variable )
    mark_as_called_and_push_whitespace
    super( variable_name, singular, variable )    
  end
  
  def end_html_tag( html_end_tag )
    mark_as_called_and_push_whitespace
    super( html_end_tag )
  end

  def self_contained_html_node( node_name )
    mark_as_called_and_push_whitespace
    super( node_name )
  end

  def start_html_tag( html_start_tag )
    mark_as_called_and_push_whitespace
    super( html_start_tag )
  end
  
  def tr_call( html_end_tag = nil, count = 0 )
    if( empty? )
      ""
    else
      to_return = ""
      to_return += @prepended_whitespace if @prepended_whitespace
      to_return += "<%= #{super(html_end_tag, count) } %>"
      to_return += @last_whitespace_node if @last_whitespace_node
      to_return
    end
  end

  def white_space( white_space_text, queue = true )
    if( first_call? )
      @prepended_whitespace = white_space_text
    elsif( !queue )
      super( white_space_text )
      @last_whitespace_node = nil
    else
      super( @last_whitespace_node ) unless @last_whitespace_node.nil?
      @last_whitespace_node = white_space_text
    end
    
  end

  private

  def first_call?
    @call_made.nil? || @call_made == false
  end

  def mark_as_called_and_push_whitespace
    @call_made = true
    white_space( @last_whitespace_node, false ) if @last_whitespace_node
  end
  
  
end
