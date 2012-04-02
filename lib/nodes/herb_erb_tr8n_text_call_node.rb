class HerbErbTr8nTextCallNode < HerbTr8nTextCallNode

  def add_text( text_value_as_string )
    mark_as_called
    super( text_value_as_string )
  end

  def add_variable( name, value )
    mark_as_called    
    super( name, value )
  end

  
  def end_html_tag( html_end_tag )
    mark_as_called    
    super( html_end_tag )
  end

  def self_contained_html_node( node_name )
    mark_as_called    
    super( node_name )
  end

  def start_html_tag( html_start_tag )
    mark_as_called    
    super( node_name )
  end
  
  def tr_call( html_end_tag = nil, count = 0 )
    if( empty? )
      ""
    else
      to_return = ""
      to_return += @prepended_whitespace if @prepended_whitespace
      to_return += "<%= #{super(html_end_tag, count) } %>"
      to_return
    end
  end

  def white_space( white_space_text )
    if( first_call? )
      @prepended_whitespace = white_space_text
    else
      super( white_space_text )
    end
    
  end

  private

  def first_call?
    @call_made.nil? || @call_made == false
  end

  def mark_as_called
    @call_made = true
  end
  
  
end
