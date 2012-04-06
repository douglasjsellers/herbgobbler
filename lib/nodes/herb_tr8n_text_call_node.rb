class HerbTr8nTextCallNode

  attr_reader :variable_name_being_assigned_to
  
  def initialize( html_start_tag = nil )
    @text_values = []
    @variable_names_and_values = []
    @child_text_call_node = nil
    @html_start_tag = html_start_tag
    @variable_name_being_assigned_to = html_start_tag.tag_name.text_value unless html_start_tag.nil?
    @number_of_html_nodes = 0
  end

  def add_text( text_value_as_string )
    unless( processing_nested_html? )
      @text_values << HerbTr8nStringNode.new( text_value_as_string )
    else
      @child_text_call_node.add_text( text_value_as_string )
    end
  end

  def add_variable( name, value )
    unless( processing_nested_html? )
      @variable_names_and_values << [name, value]
      @text_values << "{#{name}}"
    else
      @child_text_call_node.add_variable( name, value )
    end
  end

  def add_pluralization( variable, singular )
    variable_name = convert_variable_to_variable_name( variable )
    @text_values << "[#{variable_name} || #{singular}]"
    @variable_names_and_values << [variable_name, variable ]
  end

  
  def being_assigned_to_variable?
    !@variable_name_being_assigned_to.nil?
  end

  def block_variable
    to_return = "[#{variable_name_being_assigned_to}: "
    to_return += text_values_as_concated_string
    to_return += "]"
    to_return
  end

  def empty?
    @text_values.empty? && @variable_names_and_values.empty? && @child_text_call_node.nil?
  end
  
  def end_html_tag( html_end_tag )
    @variable_names_and_values << [@child_text_call_node.variable_name_being_assigned_to, @child_text_call_node.tr_call(html_end_tag, @number_of_html_nodes) ]
    @number_of_html_nodes += 1
    @child_text_call_node = nil
  end
  
  def processing_nested_html?
    !@child_text_call_node.nil?
  end
  
  def self_contained_html_node( node_name )
    unless( processing_nested_html? )
      @text_values << "{#{node_name}}"
    else
      @child_text_call_node.add_variable( node_name )
    end
    
  end

  def start_html_tag( html_start_tag )
    @child_text_call_node = HerbTr8nTextCallNode.new( html_start_tag )
    @text_values << @child_text_call_node
  end


  def text_value
    if( being_assigned_to_variable? )
      block_variable
    else
      tr_call
    end
  end

  def text_values_as_concated_string
    to_return = ""
    @text_values.each do |text_value|
      to_return += text_value.to_s
    end
    to_return
  end

  def to_s
    text_value
  end
  
  def tr_call( html_end_tag = nil, count = 0 )
    to_return = ""
    unless( empty? )
      to_return += 'tr( "'

      to_return += @html_start_tag.text_value if being_assigned_to_variable?

      if( being_assigned_to_variable? )
        to_return += "{$#{count}}"
      else
        to_return += text_values_as_concated_string      
      end


      to_return += html_end_tag.text_value if being_assigned_to_variable?
      
      to_return +='"'
      
      unless( @variable_names_and_values.empty? )
        to_return += ", nil, { "
        @variable_names_and_values.each do |variable_name_value|
          to_return += ":#{variable_name_value.first} => #{variable_name_value.last}"
          to_return += ", " unless variable_name_value == @variable_names_and_values.last
        end
        to_return += " }"
      end
      
      to_return += ' )'
    end
    to_return
  end

  def white_space( white_space_text )
    unless( processing_nested_html? )
      
      @text_values << ( HerbTr8nStringNode.new( white_space_text ) ).to_s
    else
      @child_text_call_node.white_space( white_space_text )
    end
  end

  private
  def convert_variable_to_variable_name( variable )
    variable.gsub( "@", "" ).gsub( ":", "" ).gsub( ".", "_" )
  end

end

