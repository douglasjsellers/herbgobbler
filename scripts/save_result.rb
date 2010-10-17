test_to_save = ARGV.first
test_name = test_to_save.split( '/' ).last

`ruby scripts/extract_text_from_erb.rb #{test_to_save} > tests/integration/result/erb/#{test_name}.result`

`ruby scripts/extract_yml_from_erb.rb #{test_to_save} > tests/integration/result/yml/#{test_name}.yml.result`

puts "Wrote: tests/integration/result/erb/#{test_name}.result"
puts "Wrote: tests/integration/result/yml/#{test_name}.yml.result"
