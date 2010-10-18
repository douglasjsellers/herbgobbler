require File.dirname(__FILE__) + '/../spec_helper'

describe RailsTextExtractor do

  it "should be able to extract text and combined nodes" do
    erb_file = ErbFile.from_string( "<a>Yay!</a>" )
    text_extractor = RailsTextExtractor.new    
    erb_file.extract_text( text_extractor )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.text_value.should == "<%= t '.yay' %>"
    
  end

end

