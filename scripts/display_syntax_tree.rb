require 'lib/herbgobbler'


file_name = ARGV.first
erb_file = ErbFile.load( file_name )
top_levels = erb_file.flatten_elements

puts "---------- Original ----------------"
puts File.read( file_name )
puts "---------- Un-Combined Syntax Tree -------------"
top_levels.each do |top_level|
  puts top_level.text_value
end
puts "---------- Combined Syntax Tree -------------"
erb_file.combine_nodes( erb_file.flatten_elements ).each do |element|
  puts "`#{element.text_value}`(text=#{element.is_a?(TextNode)})(combindable=#{element.is_a?(NonTextNode) && element.can_be_combined?})"
end

