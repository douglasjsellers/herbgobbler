module MethodCallNode
  include TextNode

  def extract_text( text_extractor, node_tree, surrounding_nodes = nil )
    text_string = ''
    self.elements.each do |node|
      if( node.is_a?( TextNode ) )
        translated_node = text_extractor.translate_text( node.text_value )
        text_string << "(#{translated_node.text_value})"
      else
        text_string << node.text_value
      end   
    end

    if( surrounding_nodes.nil? )
      node_tree << HerbNonTextNode.new( text_string )
    elsif( surrounded_by_text? (surrounding_nodes) )
      text_extractor.add_variable( generate_i18n_key( text_extractor, node_tree ).to_s, text_string.strip )
    else
      node_tree << HerbNonTextNode.new( "<%= #{text_string.strip} %>" )
    end
    
  end

  private

  def surrounded_by_text?( nodes )
    # if the surrounding nodes only contain myself and <%= and %> then this
    # is not surrounded by text
    count_non_whitespace_nodes( nodes ) > 3 
  end

  def count_non_whitespace_nodes( nodes )
    node_count = 0
    
    nodes.each do |node|
      node_count += 1 unless node.text_value.strip.empty?
    end

    node_count
  end
  
  
  
end
