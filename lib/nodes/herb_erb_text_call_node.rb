class HerbErbTextCallNode

  def initialize( text_values = [], key_store = [], prepend = nil, postpend = nil, variables = [], include_markup = true )
    @text_values = text_values
    @prepend = prepend
    @postpend = postpend
    @key_store = key_store
    @key_value = nil
    @include_markup = include_markup
    @variables = variables
  end

  def add_text( text )
    @text_values << text
  end

  def can_be_combined?
    true
  end
  
  def key_value
    if( @key_value.nil? )
      @key_value = I18nKey.new( original_text, @key_store ).key_value
    end

    @key_value
  end

  def node_name
    "herb_erb_text_call_node"
  end
  
  def original_text
    @text_values.join( '' )
  end
  
  def text_value
    string_to_return = "#{@prepend}#{key_value}#{@postpend}"
    string_to_return += ", #{@variables.join( ', ' )}" unless @variables.empty?
    if( @include_markup )
      "<%= #{string_to_return} %>"
    else
      string_to_return
    end
      
  end
  
  def to_s
    text_value
  end
  
end
