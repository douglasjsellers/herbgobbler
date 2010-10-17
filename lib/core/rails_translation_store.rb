class RailsTranslationStore < BaseTranslationStore

  def initialize( language = "en" )
    super()
    @language = language
  end

  # This goes out of it's way to keep things in exactly the correct
  # order.  This makes it easier for translators when dealing with
  # files.  This is the reason to not just throw things into a hash
  # and serialize the hash
  def serialize
    to_return = "#{@language}:\n"
    last_context = nil
    self.each do |context, key, value|
      whitespace_depth = 2
      context_array = context.split('/')
      context_array.each do |split_context|
        to_return << "#{build_whitespace( whitespace_depth )}#{split_context}:\n" 
        whitespace_depth += 2
      end unless context == last_context
      if( value.index( "\n" ) )
        to_return << "#{build_whitespace( 2 + 2 * context_array.length )}#{key}:  |\n#{add_value_whitespace( 2 + 2 * (context_array.length + 3), value )}\n"
        
      else
        to_return << "#{build_whitespace( 2 + 2 * context_array.length )}#{key}: \"#{escape(value)}\"\n"
      end
      
      last_context = context
    end
    
    to_return.chomp
  end

  private

  def build_whitespace( amount )
    " " * amount
  end

  private

  def add_value_whitespace( amount, value )
    "#{build_whitespace( amount )}#{value.gsub( "\n", "\n#{build_whitespace( amount )}" )}"
  end
  
  def escape( key )
    key.gsub( /"/, '\"' )
  end
  
end
