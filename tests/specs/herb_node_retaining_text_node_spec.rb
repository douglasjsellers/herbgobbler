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


  it "shoulh return true to can_strip_nodes? if the first node is a end tag" do
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
  
end

