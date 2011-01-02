class I18nKey
  
  def initialize( text, key_store = [] )
    @text = text
    @key_store = key_store
    @key_value = nil
  end

  def key_value
    if( @key_value.nil? )
      to_return = remove_html_tags( @text )
      to_return = to_return.gsub( /[%{].*[}]/, '' )
      to_return = to_return.gsub( /[^a-zA-Z0-9]/, ' ' )
      to_return = to_return.squeeze.strip.downcase.chomp
      to_return = to_return.gsub( / /, '_' )
      to_return = cut_down_to_size( to_return )
      to_return = ensure_no_duplicates( to_return )
      self.key_value = to_return
    end
    @key_value
  end

  def key_value=(value)
    @key_value = value
    @key_store << value
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

  def exists_in_keystore?( value )
    !(@key_store.index( value ).nil?)
  end
  
  def ensure_no_duplicates( key_value, incrementor = 1 )
    if( exists_in_keystore?( key_value ) )
      incremented_value = "#{key_value}_#{incrementor}"
      if( exists_in_keystore?( incremented_value ) )
        ensure_no_duplicates( key_value, incrementor + 1 )
      else
        incremented_value
      end
    else
      key_value
    end
  end
      
  def remove_html_tags( string_to_remove )
    string_to_remove.gsub( /<[\/]?[a-zA-Z]+[^<]*>/, '_')
  end
  
  
  
end
