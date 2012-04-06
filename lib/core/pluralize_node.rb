module PluralizeNode
  include TextNode
  attr_reader :variable_name, :variable_value
  
  def extract_text( text_extractor, node_tree, surrounding_nodes = nil )
    set_variable_name_and_value( text_extractor, node_tree, surrounding_nodes )
    text_extractor.pluralize( self )
  end

  private

  def set_variable_name_and_value( text_extractor, node_tree, surrounding_nodes )
    @variable_value = ''
    self.elements.each do |node|        
      if( node.is_a?( TextNode ) )
        translated_node = text_extractor.translate_text( node.text_value )
        @variable_value << "(#{translated_node.text_value})"
      else
        @variable_value << node.text_value
      end   
    end
    @variable_value = @variable_value.strip
    @variable_name = generate_i18n_key( text_extractor, node_tree ).to_s
    
  end
  
end
