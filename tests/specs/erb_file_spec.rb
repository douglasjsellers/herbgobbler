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

  it "should be able to roll up multiple characters into a single top level element" do
    erb_file = ErbFile.from_string( "Doug" )
    terminals = erb_file.accumulate_top_levels    
    terminals.size.should == 1
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "Doug" 
    
  end
  
  it "should be able to roll up multiple characters into a single top level element when surrounded by <br/> tags" do
    erb_file = ErbFile.from_string( "<br/>Doug<br/>" )
    terminals = erb_file.accumulate_top_levels    
    terminals.size.should == 3
    
    terminals[0].top_level?.should == true
    terminals[0].text?.should == false
    terminals[0].node_name.should == "html_self_contained"
    terminals[0].text_value.should == "<br/>" 
    
    terminals[1].top_level?.should == true
    terminals[1].text?.should == true
    terminals[1].node_name.should == "text"
    terminals[1].text_value.should == "Doug" 

    terminals[2].top_level?.should == true
    terminals[2].text?.should == false
    terminals[2].node_name.should == "html_self_contained"    
    terminals[2].text_value.should == "<br/>" 
  end

  it "should be able to correctly roll up text when that text is surrounded by html tags" do
    
    erb_file = ErbFile.from_string( "<b>Doug</b>" )
    terminals = erb_file.accumulate_top_levels    
    terminals.size.should == 3
    
    terminals[0].top_level?.should == true
    terminals[0].text?.should == false
    terminals[0].node_name.should == "html_start_tag"
    terminals[0].text_value.should == "<b>" 
    
    terminals[1].top_level?.should == true
    terminals[1].text?.should == true
    terminals[1].node_name.should == "text"
    terminals[1].text_value.should == "Doug" 

    terminals[2].top_level?.should == true
    terminals[2].text?.should == false
    terminals[2].node_name.should == "html_end_tag"    
    terminals[2].text_value.should == "</b>" 
    
  end

  it "should be able to roll up text when it is surrounded by erb blocks and strings" do
    erb_file = ErbFile.from_string( "Doug<%= is? %>Great<% @title='blah' %>" )
    terminals = erb_file.accumulate_top_levels    
    terminals.size.should == 4

    terminals[0].top_level?.should == true
    terminals[0].text?.should == true
    terminals[0].node_name.should == "text"
    terminals[0].text_value.should == "Doug" 

    terminals[1].top_level?.should == true
    terminals[1].text?.should == false
    terminals[1].node_name.should == "erb_string"
    terminals[1].text_value.should == "<%= is? %>" 

    terminals[2].top_level?.should == true
    terminals[2].text?.should == true
    terminals[2].node_name.should == "text"
    terminals[2].text_value.should == "Great" 

    terminals[3].top_level?.should == true
    terminals[3].text?.should == false
    terminals[3].node_name.should == "erb_block"
    terminals[3].text_value.should == "<% @title='blah' %>" 
    
  end
  
  
  
  
end
