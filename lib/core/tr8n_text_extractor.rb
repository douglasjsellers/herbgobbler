class Tr8nTextExtractor < BaseTextExtractor

  def initialize
    @current_node = nil
    @debug = false
  end
  
  # This is called when text extraction has begun
  def starting_text_extraction
  end

  def add_html_text( text_node )
    puts "Adding html text: #{text_node.text_value}" if @debug
    @current_node.add_text( text_node.text_value )
  end

  def add_variable( variable_name, variable_value )
    puts "Adding variable: #{variable_name} = #{variable_value}" if @debug
    @current_node.add_variable( variable_name, variable_value )
  end

  def translate_text( text_node_to_translate )
    puts "Translating text: #{text_node_to_translate}" if @debug
    # This should just return a node that responds to text_value
    to_return = HerbTr8nTextCallNode.new
    to_return.add_text( text_node_to_translate )
    to_return
    
  end
  
  def end_html_text
    puts "End HTML Text" if @debug
    to_return = @current_node
    @current_node = nil
    [to_return]
  end

  def pluralize( pluralize_node, variable_name )
    variable = pluralize_node.repetition.text_value
    singluar = pluralize_node.string_to_pluralize.text_value
    variable_name
    @current_node.add_pluralization( variable_name, singluar, variable )
  end
  
  def start_html_text
    puts "Starting html text" if @debug
    @current_node = HerbErbTr8nTextCallNode.new
  end
    
  def completed_text_extraction
  end

  def white_space( node )
    puts "Whitespace" if @debug
    @current_node.white_space( node.text_value )
  end

  def add_non_text( non_text_node )
    puts "Adding non text" if @debug
    if( non_text_node.node_name == 'html_start_tag' )
      start_html_tag( non_text_node )
    elsif( non_text_node.node_name == 'html_end_tag' )
      end_html_tag( non_text_node )
    elsif( non_text_node.node_name == 'html_self_contained' )
      self_contained_html_node( non_text_node )
    end
  end

  def start_html_tag( html_start_node )
    puts "Start html tag" if @debug
    @current_node.start_html_tag( html_start_node )
  end
  
  def end_html_tag( html_end_node )
    puts "End html tag" if @debug
    @current_node.end_html_tag( html_end_node )
  end

  def self_contained_html_node( html_self_contained_node )
    puts "Self contained html node" if @debug
    @current_node.self_contained_html_node( html_self_contained_node.tag_name.text_value )
  end
  
  
  
end
