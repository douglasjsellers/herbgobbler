class HerbStringVariable < Treetop::Runtime::SyntaxNode
  include TextNode

  def node_name
    "herb_string_variable"
  end
  
  def extract_text( text_extractor, node_tree )
    text_extractor.add_variable( I18nKey.new( self.variable.text_value, get_key_hash(text_extractor, node_tree) ).to_s , self.variable.text_value )    
  end
  
  
end
