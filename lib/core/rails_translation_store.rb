class RailsTranslationStore < BaseTranslationStore

  def initialize( language = "en" )
    super()
    @language = language    
  end


  def self.load_from_file( full_path_to_file, language = "en" )
    self.load_from_string( File.read( full_path_to_file ), language )
  end
  
  # This is used to load an existing rails transaltion store (in yaml
  # format) to a new rails translation store
  def self.load_from_string( string, language = "en" )
    to_return = RailsTranslationStore.new( language )
    yaml = YAML.load( string )
    yaml['en'].each_pair do |language, translations|
      to_return.start_new_context( language )
      translations.each_pair do |key,value|
        to_return.add_translation( key, value )
      end
    end
    to_return
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
        to_return << "#{build_whitespace( 2 + 2 * context_array.length )}#{key}: \"#{escape(value)}\"\n"
      last_context = context
    end
    
    to_return.chomp
  end

  private

  def build_whitespace( amount )
    " " * amount
  end

  private

  
  def escape( key )
    key.gsub( /"/, '\"' ).gsub( "\n", "\\n" )
  end
  
end
