class HerbStringVariable < Treetop::Runtime::SyntaxNode
  include TextNode
  
  def extract_text( text_extractor, node_tree )
    text_extractor.add_variable( I18nKey.new( self.variable.text_value, [] ).to_s , self.variable.text_value )
  end

  
  
end
