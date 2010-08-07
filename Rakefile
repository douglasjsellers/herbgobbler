require 'lib/herbgobbler'

desc "Run the compliation tests"
task :test_compilation do
  puts "Running compilation tests"
  complitaion_test_success = true
  success_directory = 'tests/compilation/success'
  Dir.new( success_directory ).reject {|f| [".", ".."].include? f}.each do |file|
    full_path_to_file = "#{success_directory}/#{file}"
    erb_file = ErbFile.load( full_path_to_file )
    if( erb_file.compiled? )
      puts "Success #{full_path_to_file}"
    else
      complitaion_test_success = false
      puts "Failed #{full_path_to_file}"
      puts "For reason: #{ErbFile.debug( full_path_to_file ) }"
    end
  end

  puts
  if( complitaion_test_success )
    puts "Compilation Test Success"
  else
    puts "Compilation Test Failure"
  end
end

desc "Run all of the tests"
task :test => [:test_compilation] do
end

task :default => [:test]

