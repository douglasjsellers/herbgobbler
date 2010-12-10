class DoubleQuotedTextNode < Treetop::Runtime::SyntaxNode  
  include TextNode
  
  def has_variables?
    leaves.any? { |node| node.is_a?( HerbStringVariable ) }
  end
  
  def leaves
    leaves_to_return = []
    original_elements.each do |element|
      leaves_to_return += flatten element
    end unless original_elements.nil? || original_elements.empty?
    leaves_to_return
  end
  
  alias :original_elements :elements
  alias :original_text_value :text_value
  
  def elements
    if( has_variables? )
      variable_elements
    else
      original_elements
    end
  end

  def text_value
    if( has_variables? )
      elements.inject('') { |string, current_element| string += current_element.text_value }
    else
      original_text_value
    end
    
  end
  
  def variable_elements
    found_elements = []
    current_text = ''
    leaves.each do |leaf|
      if( leaf.is_a?( HerbStringVariable ) )
        found_elements = add_text_to_array( found_elements, current_text )
        current_text = ''
        found_elements << leaf
      else
        current_text += leaf.text_value unless( leaf.nil? || leaf.text_value.empty? )
      end
    end
    found_elements = add_text_to_array( found_elements, current_text )
    found_elements
  end

  private

  def add_text_to_array( array, text )
    unless( text.empty? )
      array << HerbTextNode.new( text )
    end
    array
  end
  

end
