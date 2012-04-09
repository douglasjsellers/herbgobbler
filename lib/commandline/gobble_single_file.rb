class GobbleSingleFile
  include GobbleShare
  
  def initialize( rails_root, type, options )
    @rails_root = rails_root
    @options = options
    @text_extractor_type = type
  end

  def execute
    file_name = @options.first
    if( @text_extractor_type == 'tr8n' )
      execute_tr8n( file_name )
    else
      execute_i18n( file_name )
    end
    
  end

  def valid?
    @options.size == 1
  end

  private

  def execute_tr8n( file_name )
    rails_view_directory = "#{@rails_root}/app/views"
    erb_file = "/app/#{file_name.gsub( /.*\/app\//, '' )}"
    puts "Gobbling file: #{file_name}"
    puts ""

    # load erb file into tr8n translation store
    text_extractor = Tr8nTextExtractor.new
    
    erb_file = ErbFile.load( file_name )
    erb_file.extract_text( text_extractor )
    
    # write file
    File.open(file_name, 'w') {|f| f.write(erb_file.to_s) }
    
  end
  
  def execute_i18n( file_name )
    locale_file_name = "en.yml"
    rails_view_directory = "#{@rails_root}/app/views"
    full_yml_file_path = "#{@rails_root}/config/locales/#{locale_file_name}"
    erb_file = "/app/#{file_name.gsub( /.*\/app\//, '' )}"
    puts "Gobbling file: #{file_name}"
    puts ""

    # load erb file into rails translation store
    rails_translation_store = RailsTranslationStore.load_from_file( full_yml_file_path )
    text_extractor = RailsTextExtractor.new( rails_translation_store )
    
    # open file to process
    rails_translation_store.start_new_context( convert_path_to_key_path( erb_file.to_s ) )
    
    erb_file = ErbFile.load( file_name )
    erb_file.extract_text( text_extractor )
    
    # write file
    File.open(file_name, 'w') {|f| f.write(erb_file.to_s) }

    # re-write yml file
    File.open(full_yml_file_path, 'w') {|f| f.write(rails_translation_store.serialize) }    
  end
  
  
end
