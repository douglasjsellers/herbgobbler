require 'lib/herbgobbler'

@indent = 0
@print_deep = true
def print_sub_elements( sub_element )
  @indent += 5
  sub_element.elements.each do |element|
    puts " " * @indent + "#{element.text_value}" if element.respond_to?(:node_name)
    print_sub_elements( element ) if @print_deep
  end if sub_element.respond_to?( :elements ) && !sub_element.elements.nil?
  @indent -= 5
end

file_name = ARGV.first
top_levels = ErbFile.load( file_name ).accumulate_top_levels

puts "---------- Original ----------------"
puts File.read( file_name )
puts "---------- Syntax Tree -------------"
top_levels.each do |top_level|
  puts "Top Level: #{top_level.node_name}: #{top_level.text_value}"
  print_sub_elements( top_level )
end

