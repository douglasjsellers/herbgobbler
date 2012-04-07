class HerbStringVariable < Treetop::Runtime::SyntaxNode
  include TextNode

  def node_name
    "herb_string_variable"
  end

  def extract_text( text_extractor, node_tree )
    pluralize = find_pluralize_node(variable)
    
    # if this variable is a pluralize node, then don't treat it like a
    # variable but like a pluralize
    unless( pluralize.nil? )
      variable_name = I18nKey.new( pluralize.repetition.text_value, get_key_hash(text_extractor, node_tree) ).to_s      
      text_extractor.pluralize( pluralize, variable_name )
    else
      text_extractor.add_variable( I18nKey.new( self.variable.text_value, get_key_hash(text_extractor, node_tree) ).to_s , self.variable.text_value )    
    end
    
  end
  
  private

  # Unravel all the nodes to see if there is a pluralize node
  def find_pluralize_node( node )
    unless( node.elements.nil? || node.elements.empty? )
      node.elements.each do |element|
        if element.is_a?(PluralizeNode )
          return element
        else
          found_node = find_pluralize_node( element )
          return found_node unless found_node.nil?
        end
      end
    end
    nil
  end
  
    
end
