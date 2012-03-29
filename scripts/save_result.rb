#!/usr/bin/env ruby

test_to_save = ARGV.first
test_name = test_to_save.split( '/' ).last

`ruby scripts/extract_text_from_erb.rb i18n #{test_to_save} > tests/integration/result/erb/#{test_name}.i18n.result`

`ruby scripts/extract_text_from_erb.rb tr8n #{test_to_save} > tests/integration/result/erb/#{test_name}.tr8n.result`

`ruby scripts/extract_yml_from_erb.rb #{test_to_save} > tests/integration/result/yml/#{test_name}.yml.i18n.result`

puts "Wrote: tests/integration/result/erb/#{test_name}.i18n.result"
puts "Wrote: tests/integration/result/yml/#{test_name}.yml.i18n.result"
