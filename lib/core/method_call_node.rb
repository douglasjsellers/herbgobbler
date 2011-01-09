module MethodCallNode
  include TextNode

  def extract_text( text_extractor, node_tree )
    text_string = ''
    self.elements.each do |node|
      if( node.is_a?( TextNode ) )
        translated_node = text_extractor.translate_text( node.text_value )
        text_string << "(#{translated_node.text_value})"
      else
        text_string << node.text_value
      end   
    end

    text_extractor.add_variable( generate_i18n_key( text_extractor, node_tree ).to_s, text_string.strip )
    
  end
  
end
