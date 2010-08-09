require 'lib/herbgobbler'

file_name = ARGV.first
puts ErbFile.load( file_name ).to_s
