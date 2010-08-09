require 'lib/herbgobbler'

file_name = ARGV.first
top_levels = ErbFile.load( file_name ).accumulate_top_levels

puts "---------- Original ----------------"
puts File.read( file_name )
puts "---------- Syntax Tree -------------"
top_levels.each do |top_level|
  puts "#{top_level.node_name}: #{top_level.text_value}"
end

