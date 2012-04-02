#!/usr/bin/env ruby
require 'backports'
require_relative '../lib/herbgobbler'

def print_usage
  puts "usage: ruby extract_text_from_erb.rb i18n|tr8n <file name>"
end

if( ARGV.length != 2 )
  print_usage
else
  engine = ARGV.first
  file_name = ARGV.last
  if( engine == 'i18n' )
    text_extractor = RailsTextExtractor.new
    erb_file = ErbFile.load( file_name )
    erb_file.extract_text( text_extractor )
    print erb_file.to_s
  elsif( engine == 'tr8n' )
    text_extractor = Tr8nTextExtractor.new
    erb_file = ErbFile.load( file_name )
    erb_file.extract_text( text_extractor )
    print erb_file.to_s    
  else
    print_usage
  end
end







