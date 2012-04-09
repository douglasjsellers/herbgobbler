class HerbTr8nTextCallNode

  attr_reader :variable_name_being_assigned_to
  
  def initialize( html_start_tag = nil, tag_count = 0 )
    @text_values = []
    @variable_names_and_values = []
    @html_start_tag = html_start_tag
    @variable_name_being_assigned_to = html_start_tag.tag_name.text_value unless html_start_tag.nil?
    @number_of_html_nodes = tag_count
    @child_nodes = []
  end

  def add_text( text_value_as_string )
    @text_values << HerbTr8nStringNode.new( text_value_as_string )
  end

  def add_child( child_node )
    @child_nodes << child_node
    @text_values << child_node
  end
  
  def add_variable( name, value )
    @variable_names_and_values << [name, value]
    @text_values << "{#{name}}"
  end

  def add_pluralization( variable_name, singular, variable )
    @text_values << "[#{variable_name} || #{singular}]"
    @variable_names_and_values << [variable_name, variable ]
  end

  
  def being_assigned_to_variable?
    !@variable_name_being_assigned_to.nil?
  end

  def closing_tag_for_this_node?( closing_tag )
    ( !@html_start_tag.nil? && @html_start_tag.tag_name.text_value == closing_tag.tag_name.text_value )
  end
  
  def block_variable
    to_return = "[#{variable_name_being_assigned_to}: "
    to_return += text_values_as_concated_string
    to_return += "]"
    to_return
  end

  def empty?
    @text_values.empty? && @variable_names_and_values.empty?
  end
  
  def end_html_tag( html_end_tag )
    @variable_names_and_values << [self.variable_name_being_assigned_to, self.variable_string( html_end_tag, @number_of_html_nodes) ]
  end
  
  
  def self_contained_html_node( node_name )
      @text_values << "{#{node_name}}"
  end

  def start_html_tag( html_start_tag )
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

  def variables
    to_return = @variable_names_and_values.dup
    @child_nodes.each do |child_node|
      to_return += child_node.variables
    end
    to_return
  end
  
  def to_s
    text_value
  end

  def variable_string( html_end_tag, count )
    to_return = "\""
    to_return += @html_start_tag.text_value 
    to_return += "{$#{count}}"
    to_return += html_end_tag.text_value
    to_return += "\""
    to_return
  end
  
  def tr_text( html_end_tag = nil, count = 0 )
    to_return = "\""
    unless( empty? )
      to_return += @html_start_tag.text_value if being_assigned_to_variable?

      if( being_assigned_to_variable? )
        to_return += "{$#{count}}"
      else
        to_return += text_values_as_concated_string      
      end

      to_return += html_end_tag.text_value if being_assigned_to_variable?
      
      to_return +='"'
      
      unless( self.variables.empty? )
        to_return += ", nil, { "
        self.variables.each do |variable_name_value|
          to_return += ":#{variable_name_value.first} => #{variable_name_value.last}"
          to_return += ", " unless variable_name_value == variables.last
        end
        to_return += " }"
      end
    end

    to_return
  end
  
  def tr_call( html_end_tag = nil, count = 0 )
    to_return = ""
    unless( empty? )
      to_return += 'tr( '
      to_return += tr_text( html_end_tag, count )
      to_return += ' )'
    end
    to_return
  end

  def white_space( white_space_text )
    @text_values << ( HerbTr8nStringNode.new( white_space_text ) ).to_s
  end

end

