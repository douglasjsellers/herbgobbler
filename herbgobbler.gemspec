Gem::Specification.new do |s|
  s.name = "herbgobbler"
  s.version = "0.3.0"
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'gobble'
  s.required_ruby_version = ">= 1.8.7"
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{bin,lib,scripts,grammer}/**/*").to_a
  s.test_files = Dir.glob("{test}/**/*")
  s.required_rubygems_version = ">= 1.3.7"
  s.author = "Douglas Sellers"
  s.email = %q{douglas.sellers@gmail.com}
  s.summary = %q{Allows english text extraction, for internationalization and localization, from Ruby on Rails ERB files}
  s.homepage = %q{https://github.com/douglasjsellers/herbgobbler}
  s.description = %q{Allows english text extraction, for internationalization and localization, from Ruby on Rails ERB files}

  s.add_dependency( 'bundler', '>=1.0.2' )
  s.add_dependency( 'polyglot', '>=0.3.1' )
  s.add_dependency( 'treetop', '>=1.4.8' )
end


