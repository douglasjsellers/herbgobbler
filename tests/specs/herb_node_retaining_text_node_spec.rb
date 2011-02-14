require File.dirname(__FILE__) + '/../spec_helper'

describe HerbNodeRetainingTextNode do
  it "should be able to identify if two tags are correctly wrapped around a text tag" do
    erb_file = ErbFile.from_string( "<a>Doug</a>" )
    erb_file.nodes.size.should == 3

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true
  end

  it "should not report a false positive if only the leading tag is present" do
    erb_file = ErbFile.from_string( "<a>Doug" )
    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == false
  end

  it "should not report a false positive if only the trailing tag is present" do
    erb_file = ErbFile.from_string( "Doug</a>" )
    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == false
    
  end

  it "should be able to break off the leading and trailing text nodes if they are present" do
    erb_file = ErbFile.from_string( "<a>Doug</a>" )
    erb_file.nodes.size.should == 3

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true

    tags = node.break_out_start_and_end_tags
    tags.size.should == 3

    tags.first.text_value.should == "<a>"
    tags.last.text_value.should == "</a>"
    tags[1].text_value.should == "Doug"
    
  end

  it "should be able to break off the leading and trailing tag nodes even if there is whitespace at the end" do
    erb_file = ErbFile.from_string( "<a>Doug</a>\n" )

    erb_file.nodes.size.should == 4

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true

    tags = node.break_out_start_and_end_tags
    tags.size.should == 3

    tags.first.text_value.should == "<a>"
    tags.last.text_value.should == "</a>\n"
    tags[1].text_value.should == "Doug"
    
  end

  it "should be able to break off the leading and trailing tag nodes even if there is whitespace at the begining" do
    erb_file = ErbFile.from_string( "\n<a>Doug</a>" )

    erb_file.nodes.size.should == 4

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true

    tags = node.break_out_start_and_end_tags
    tags.size.should == 3

    tags.first.text_value.should == "\n<a>"
    tags.last.text_value.should == "</a>"
    tags[1].text_value.should == "Doug"
    
  end


  it "should return true to can_strip_nodes? if the first node is a end tag" do
    erb_file = ErbFile.from_string( "</a>Doug" )

    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true
  end

  it "should return true to can_strip_nodes? if the last node is a start tag" do
    erb_file = ErbFile.from_string( "Doug<a>" )

    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true
    
  end

  it "should be able to break off the trailing node if it is a start html tag" do
    erb_file = ErbFile.from_string( "Doug<a>" )

    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true

    tags = node.break_out_start_and_end_tags
    tags.size.should == 2

    tags.last.text_value.should == "<a>"
    tags.first.text_value.should == "Doug"
    
  end

  it "should be able to break off the leading node if it is a end html tag" do
    erb_file = ErbFile.from_string( "</a>Doug" )

    erb_file.nodes.size.should == 2

    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )
    node.can_remove_starting_or_ending_html_tags?.should == true

    tags = node.break_out_start_and_end_tags
    tags.size.should == 2

    tags.first.text_value.should == "</a>"
    tags[1].text_value.should == "Doug"
    
  end

  it "should be able to detect that something made up of only a tags and whitespace should be exploded" do
    erb_file = ErbFile.from_string( "\n<a href='blah'>stuff</a>\n<a href='two'>more</a>\n" )
    erb_file.nodes.size.should == 9
    
    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )

    node.can_be_exploded?.should == true
  end

  it "should be able to detect that something made up of a tags, text and whitespace should not be exploded" do
    erb_file = ErbFile.from_string( "\n<a href='blah'>stuff</a>Yay Doug!<a href='two'>more</a>\n" )
    erb_file.nodes.size.should == 9
    
    node = HerbNodeRetainingTextNode.new
    node.add_all( erb_file.nodes )

    node.can_be_exploded?.should == false
    
  end
  
end

