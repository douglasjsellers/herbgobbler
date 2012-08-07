require 'yaml'

class RailsTranslationStore < BaseTranslationStore

  def initialize( language = "en" )
    super()
    @language = language    
  end


  def self.load_from_file( full_path_to_file, language = "en" )
    if( File.exists?( full_path_to_file ) )
      RailsTranslationStore.load_from_string( File.read( full_path_to_file ), language )
    else
      RailsTranslationStore.new( language )
    end
  end
  
  # This is used to load an existing rails transaltion store (in yaml
  # format) to a new rails translation store
  def self.load_from_string( string, language = "en" )
    to_return = RailsTranslationStore.new( language )
    yaml = YAML.load( string )
    yaml['en'].each_pair do |language, translations|
      self.process_yaml_pair( to_return, language, translations, language )
    end if yaml['en'].respond_to?(:each_pair)
    to_return
  end

  def self.process_yaml_pair( translation_store, key, value, base_directory_like_key )
    if( value.is_a?( Hash ) )
      value.each_pair do |key, value|
        directory_like_key = base_directory_like_key
        if( value.is_a?( Hash ) )
          directory_like_key = "#{directory_like_key}/" unless directory_like_key.empty?
          directory_like_key = "#{directory_like_key}#{key}"
        end
        self.process_yaml_pair( translation_store, key, value, directory_like_key )
      end
      translation_store
    else
      translation_store.start_new_context( base_directory_like_key )
      translation_store.add_translation( key, value )
      translation_store
    end
  end
  
  # This goes out of it's way to keep things in exactly the correct
  # order.  This makes it easier for translators when dealing with
  # files.  This is the reason to not just throw things into a hash
  # and serialize the hash
  def serialize
    to_return = "#{@language}:\n"
    last_context_array = []
    self.each do |context, key, value|
      whitespace_depth = 2
      new_context_array = []
      context_array = context.split('/')

      context_array.zip(last_context_array) do |new, old|
        if new != old || new_context_array.any?
          new_context_array << new
        else
          new_context_array << nil
        end
      end

      new_context_array.each do |split_context|
        if split_context != nil
          to_return << "#{build_whitespace( whitespace_depth )}#{split_context}:\n"
        end
        whitespace_depth += 2
      end
      to_return << "#{build_whitespace( 2 + 2 * context_array.length )}#{key}: \"#{escape(value)}\"\n"
      last_context_array = context_array
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
