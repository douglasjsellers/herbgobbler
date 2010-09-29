require 'lib/herbgobbler'

file_name = ARGV.first
text_extractor = RailsTextExtractor.new
erb_file = ErbFile.load( file_name )
erb_file.extract_text( text_extractor )

erb_file.nodes.each do |node|
  print node.text_value
end

