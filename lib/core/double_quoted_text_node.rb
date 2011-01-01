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
      strip_leading_and_trailing_double_quotes( variable_elements )
    else
      strip_leading_and_trailing_double_quotes( original_elements )
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

  def strip_leading_and_trailing_double_quotes( list_of_elements )
    first_element = list_of_elements.first
    last_element = list_of_elements.last

    list_of_elements = list_of_elements[ 1..list_of_elements.length - 2 ]
    first_element = remove_double_quote_at_position( first_element, 0 )
    last_element = remove_double_quote_at_position( last_element, last_element.text_value.length - 1 )
    ([first_element,list_of_elements,last_element]).flatten.compact
  end

  def remove_double_quote_at_position( element, position )
    if( element.text_value[position..position] == '"' )
      new_text = ""
      new_text += element.text_value[0..position-1] if position > 0
      new_text += element.text_value[position+1..element.text_value.length - 1] if (position + 1) < (element.text_value.length - 1)
      if( new_text.length == 0 )
        element = nil
      else
        element = HerbTextNode.new( new_text )
      end
    end

    element
  end
  
  
  def add_text_to_array( array, text )
    unless( text.empty? )
      array << HerbTextNode.new( text )
    end
    array
  end
  

end
