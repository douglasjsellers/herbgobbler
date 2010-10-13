class BaseTranslationStore

  attr_reader :context
  
  def initialize
    @context_maps = {}
  end

  def each( &block )
    @context_maps.each do |context, context_map |
      context_map.each do |key_value_pair|
        key_name, key_value = *key_value_pair
        yield context, key_name, key_value
      end
    end
  end
  
  def start_new_context( new_context )
    @context = new_context
  end
  
  def add_translation( key, value )
    context_map() << [key, value]
  end

  def serialize
    raise "Implement me"
  end

  private


  def context_map
    if( @context.nil? )
      context_name = ''
    else
      context_name = @context
    end
    @context_maps[context_name] = [] if @context_maps[context_name].nil?
    @context_maps[context_name]
  end
  

  
end
