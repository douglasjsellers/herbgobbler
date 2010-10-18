require 'lib/herbgobbler'

def print_usage
  puts "ruby scripts/rails_gobble_file.rb <rails_root> <relative_erb_file_path> <locale_file_name>"
end

if ARGV.length < 3
  print_usage()
else
  rails_root = ARGV[0]
  erb_file_path = ARGV[1]
  locale_file_name = ARGV[2]
  full_erb_file_path = "#{rails_root}/#{erb_file_path}"
  full_yml_file_path = "#{rails_root}/config/locales/#{locale_file_name}"
  
  rails_translation_store = RailsTranslationStore.new
  text_extractor = RailsTextExtractor.new( rails_translation_store )
  rails_translation_store.start_new_context( erb_file_path.split('.').first.gsub( "app/views/", '') )
  erb_file = ErbFile.load( full_erb_file_path )
  erb_file.extract_text( text_extractor )

  File.open(full_erb_file_path, 'w') {|f| f.write(erb_file.to_s) }
  puts "Wrote #{full_erb_file_path}"
  
  File.open(full_yml_file_path, 'w') {|f| f.write(rails_translation_store.serialize) }
  puts "Wrote #{full_yml_file_path}"
end



