require 'backports'
require_relative '../spec_helper'

describe ErbFile do
  it "should parse be able to load data from a string" do
    ErbFile.from_string( "<%= 'doug is great' %>" ).should_not == nil
  end

  it "should parse and shatter and erb string into it's component parts" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>" )
    terminals = erb_file.flatten_elements
    terminals.size.should == 5

    terminals[0].node_name.should == "erb_string_start"
    terminals[2].node_name.should == "double_quoted_ruby_string"
    terminals[4].node_name.should == "erb_block_end"
  end
  
  it "should be able to gather all of the top level elements together when there is only one element" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>" )
    terminals = erb_file.flatten_elements
    terminals.size.should == 5
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "<%=" 
  end

  it "should be able to gather all of the top level elements together where are are two elemest" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>D" )
    terminals = erb_file.flatten_elements
    terminals.size.should == 6
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "<%=" 

    terminals.last.top_level?.should == true
    terminals.last.text_value.should == "D"
  end

  it "should be able to gather all of the top level elements when there are three and one of them is an html element" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %><br/>D" )
    terminals = erb_file.flatten_elements
    terminals.size.should == 7

    terminals[5].top_level?.should == true
    terminals[5].text_value.should == "<br/>"
    
    terminals.last.top_level?.should == true
    terminals.last.text_value.should == "D"
    
  end

  it "should be able to roll up multiple characters into a single top level element" do
    erb_file = ErbFile.from_string( "Doug" )
    terminals = erb_file.flatten_elements
    terminals.size.should == 1
    terminals.first.top_level?.should == true
    terminals.first.text_value.should == "Doug" 
    
  end
  
  it "should be able to roll up multiple characters into a single top level element when surrounded by <br/> tags" do
    erb_file = ErbFile.from_string( "<br/>Doug<br/>" )
    terminals = erb_file.flatten_elements
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
    terminals = erb_file.flatten_elements
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
    terminals = erb_file.flatten_elements
    
    terminals.size.should == 23

    terminals[0].top_level?.should == true
    terminals[0].text?.should == true
    terminals[0].node_name.should == "text"
    terminals[0].text_value.should == "Doug" 
    
  end
  
  it "should be able to correctly serialize a simple html snippet" do
        html_text = "<b>
        Doug is great
</b>"
    erb_file = ErbFile.from_string( html_text )
    erb_file.serialize.should == html_text
  end

  it "should be able to combine simple nodes" do
    erb_file = ErbFile.from_string( "Test <a>Yay!</a>" )
    nodes = erb_file.combine_nodes( erb_file.nodes )
    nodes.size.should == 1
    nodes.first.text_value.should == "Test <a>Yay!</a>"
  end

  it "should correctly combine a tags with attributes attached to them" do
    erb_file = ErbFile.from_string( 'Blah <a href="newest">comments</a>' )
    nodes = erb_file.combine_nodes( erb_file.nodes )
    nodes.size.should == 1
    nodes.first.text_value.should == 'Blah <a href="newest">comments</a>'
  end

  it "should not combine a non combinable node followed by a combinadable node" do
    erb_file = ErbFile.from_string( '<div><a href="newest">' )
    nodes = erb_file.combine_nodes( erb_file.nodes )
    nodes.size.should == 2
    nodes.first.text_value.should == '<div>'
    nodes.last.text_value.should == '<a href="newest">'
  end

  it "should combine two non-text combinadble nodes into a single node" do
    erb_file = ErbFile.from_string( '' )
    nodes = erb_file.combine_nodes( [ CombindableHerbNonTextNode.new( "<b>" ), CombindableHerbNonTextNode.new( "     " ) ] )
    nodes.size.should == 1
  end

  it "should be able to combine a text node followed by an erb string into a combined text node" do
    erb_file = ErbFile.from_string( 'text<%= "!" %>' )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 1
    nodes.first.text_value. should == "text<%= ! %>"
    
  end

  it "shoud combine nodes together that have an attribute associated with an html tag" do
    html = 'Blah <a href="blah">Doug</a>'
    erb_file = ErbFile.from_string( html )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 1
    nodes.first.text_value.should == html
  end

  it "shoud combine nodes together that have an attribute and whitespace associated with an html tag" do
    html = "Blah <a href=\"blah\">\nDoug\n</a>"
    erb_file = ErbFile.from_string( html )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 1
    nodes.first.text_value.should == html
  end

  it "should not combine tags that are just surrounding text" do
    erb_file = ErbFile.from_string( "<b>Doug</b>" )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 3
    
  end

  it "should not combine text that has multiple sets of tags around it" do
    erb_file = ErbFile.from_string( "<a><b>Doug</b></a>" )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 5
  end

  it "should correct combine text that starts with a tag but doesn't end with the same tag" do

    erb_file = ErbFile.from_string( "<strong>Doug</strong> is great" )
    nodes = erb_file.combine_nodes( erb_file.nodes )
    nodes.size.should == 1
  end
  
  
  
  

    
end
