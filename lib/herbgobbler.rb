$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$ERB_GRAMMER_FILE = File.expand_path( "#{File.expand_path( File.dirname( __FILE__) )}/../grammer/erb_grammer.treetop" )

require 'rubygems'
require "bundler/setup"
require 'treetop'
require 'core/core'
require 'nodes/nodes'
