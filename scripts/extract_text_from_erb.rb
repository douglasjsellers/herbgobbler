require 'lib/herbgobbler'

file_name = ARGV.first
text_extractor = RailsTextExtractor.new
erb_file = ErbFile.load( file_name )
erb_file.extract_text( text_extractor )

print erb_file.to_s



