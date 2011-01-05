require File.dirname(__FILE__) + '/../spec_helper'

class TestExtractorTextNode
  
  include TextNode
  attr_accessor :text_value
  def initialize( string, whitespace = false )
    @text_value = string
    @whitespace = whitespace
  end

  def white_space?
    @whitespace
  end
end

class TestTranslationStore < BaseTranslationStore
  attr_reader :translations

  def add_translation( key, value )
    @translations ||= {}
    @count ||= 0
    @count += 1
    @translations[ @count.to_s ] = value
  end
  
end

describe RailsTextExtractor do

  it "should be able to extract text and combined nodes" do
    erb_file = ErbFile.from_string( "Blah <a>Yay!</a>" )
    text_extractor = RailsTextExtractor.new    
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == "<%= t '.blah_yay' %>"
  end

  it "should be able to combine several text nodes passed in to a single value" do
    extractor = RailsTextExtractor.new( TestTranslationStore.new )
    extractor.start_html_text
    extractor.add_html_text( TestExtractorTextNode.new( "test" ) )
    extractor.add_html_text( TestExtractorTextNode.new( "!" ) )
    resulting_nodes = extractor.end_html_text
    resulting_nodes.size.should == 1
    resulting_nodes.first.text_value.should == "<%= t '.test' %>"
    extractor.translation_store.translations.size.should == 1
    extractor.translation_store.translations.values.first.should == "test!"
  end

  it "should be able to prune all of the whitespace that proceeds text" do
    extractor = RailsTextExtractor.new( TestTranslationStore.new )
    extractor.start_html_text
    extractor.white_space( TestExtractorTextNode.new( " ", true ) )
    extractor.add_html_text( TestExtractorTextNode.new( "test" ) )
    resulting_nodes = extractor.end_html_text
    resulting_nodes.size.should == 2
    resulting_nodes.first.text_value.should == " "    
    resulting_nodes.last.text_value.should == "<%= t '.test' %>"
    extractor.translation_store.translations.size.should == 1
    extractor.translation_store.translations.values.first.should == "test"
    
  end

  it "should not prune whitespace place in the center of text" do
    extractor = RailsTextExtractor.new( TestTranslationStore.new )
    extractor.start_html_text
    extractor.add_html_text( TestExtractorTextNode.new( "test" ) )
    extractor.white_space( TestExtractorTextNode.new( " ", true ) )
    extractor.add_html_text( TestExtractorTextNode.new( "!" ) )    
    resulting_nodes = extractor.end_html_text
    resulting_nodes.size.should == 1
    resulting_nodes.last.text_value.should == "<%= t '.test' %>"
    extractor.translation_store.translations.size.should == 1
    extractor.translation_store.translations.values.first.should == "test !"
  end

  it "should prune whitespace removed from the end of the text" do
    extractor = RailsTextExtractor.new( TestTranslationStore.new )
    extractor.start_html_text
    extractor.add_html_text( TestExtractorTextNode.new( "test" ) )
    extractor.white_space( TestExtractorTextNode.new( " ", true ) )    
    resulting_nodes = extractor.end_html_text
    resulting_nodes.size.should == 2
    resulting_nodes.last.text_value.should == " "    
    resulting_nodes.first.text_value.should == "<%= t '.test' %>"
    extractor.translation_store.translations.size.should == 1
    extractor.translation_store.translations.values.first.should == "test"
  end

  it "should be able to add a variable and have it show up in the erb string generated" do
    extractor = RailsTextExtractor.new( TestTranslationStore.new )
    extractor.start_html_text
    extractor.add_html_text( TestExtractorTextNode.new( "test " ) )
    extractor.add_variable( "count", "\"1\"" )
    resulting_nodes = extractor.end_html_text
    resulting_nodes.first.text_value.should == "<%= t '.test', :count => (\"1\") %>"
  end
  
  it "should be able to add a variable and have it show up in the yml key" do
    translation_store = TestTranslationStore.new
    extractor = RailsTextExtractor.new( translation_store )
    extractor.start_html_text
    extractor.add_html_text( TestExtractorTextNode.new( "test " ) )
    extractor.add_variable( "count", "1" )
    resulting_nodes = extractor.end_html_text
    translation_store.translations["1"].should == "test %{count}"
  end
  
end

