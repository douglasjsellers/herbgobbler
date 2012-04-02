#!/usr/bin/env ruby

require 'backports'
require_relative '../lib/herbgobbler'

file_name = ARGV.first
rails_translation_store = RailsTranslationStore.new
text_extractor = RailsTextExtractor.new( rails_translation_store )
rails_translation_store.start_new_context( file_name.split('.').first )
erb_file = ErbFile.load( file_name )
erb_file.extract_text( text_extractor )

print rails_translation_store.serialize

