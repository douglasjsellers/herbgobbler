require File.dirname(__FILE__) + '/../spec_helper'

describe ErbFile do
  it "should parse be able to load data from a string" do
    ErbFile.from_string( "<%= 'doug is great' %>" ).should_not == nil
  end

  it "should be able to gather all of the top level elements together when there is only one element" do
    erb_file = ErbFile.from_string( "<%= 'doug is great' %>" )
    terminals = erb_file.accumulate_top_levels
    terminals.size.should == 1
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "<%= 'doug is great' %>" 
  end

  it "should be able to gather all of the top level elements together where are are two elemest" do
    erb_file = ErbFile.from_string( "<%= 'doug is great' %>D" )
    terminals = erb_file.accumulate_top_levels
    terminals.size.should == 2
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "<%= 'doug is great' %>" 

    terminals.last.top_level?.should == true
    terminals.last.text_value.should == "D"
  end

  it "should be able to gather all of the top level elements when there are three and one of them is an html element" do
    erb_file = ErbFile.from_string( "<%= 'doug is great' %><br/>D" )
    terminals = erb_file.accumulate_top_levels
    terminals.size.should == 3
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "<%= 'doug is great' %>" 

    terminals[1].top_level?.should == true
    terminals[1].text_value.should == "<br/>"
    
    terminals.last.top_level?.should == true
    terminals.last.text_value.should == "D"
    
  end
  
  
  
  
end
