class I18nKey
  
  def initialize( text )
    @text = text
    
  end

  def key_value
    to_return = remove_html_tags( @text )
    to_return = to_return.gsub( /[^a-zA-Z0-9]/, ' ' )
    to_return = to_return.squeeze.strip.downcase.chomp    
    to_return = to_return.gsub( / /, '_' )

    cut_down_to_size( to_return )
  end

  def to_s
    key_value
  end

  private

  def cut_down_to_size( string_to_remove )
    if( string_to_remove.length < 15 )
      string_to_remove
    else
      if( string_to_remove.rindex( '_' ) )
        cut_down_to_size( string_to_remove[0..(string_to_remove.rindex('_')-1) ] )
      else
        string_to_remove
      end
    end
  end

  def remove_html_tags( string_to_remove )
    string_to_remove.gsub( /<[\/]?[a-zA-Z]+[^<]*>/, '_')
  end
  
  
  
end
