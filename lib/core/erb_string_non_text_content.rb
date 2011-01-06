module ErbStringNonTextContent
  include NonTextNode

  def extract_text( text_extractor, node_tree )
    text_extractor.add_variable( I18nKey.new( self.text_value, get_key_hash(text_extractor, node_tree) ).to_s, self.text_value.strip ) unless self.contains_only_whitespace?
  end
  
end
