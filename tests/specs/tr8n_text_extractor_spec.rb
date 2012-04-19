require 'backports'
require_relative '../spec_helper'

describe Tr8nTextExtractor do

  it "should extract text as text" do
    erb_file = ErbFile.from_string( "This is only a test" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is only a test" ) %>'
  end
  
  it "should extract text with breaks as text" do
    erb_file = ErbFile.from_string( "This is only\n a test" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is only{br} a test" ) %>'
  end

  it "should remove nbsp's from text" do
    erb_file = ErbFile.from_string( "This is only &nbsp; a test" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is only {nbsp} a test" ) %>'
  end


  it "should do simple variable replacement" do
    erb_file = ErbFile.from_string( "This is <%= @user %> a test" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is {user} a test", nil, { :user => @user } ) %>'    
  end

  it "should do multiple variable replacement" do

    erb_file = ErbFile.from_string( "This is <%= @user %> a test <%= @count %>" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is {user} a test {count}", nil, { :user => @user, :count => @count } ) %>'    
  end

  it "should replace tags with decorations" do
    erb_file = ErbFile.from_string( "This is <b>a test</b>" )
    text_extractor = Tr8nTextExtractor.new
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == '<%= tr( "This is [b: a test]", nil, { :b => "<b>{$0}</b>" } ) %>'    
  end
  
  
  
  
end
