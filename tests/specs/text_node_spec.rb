require File.dirname(__FILE__) + '/../spec_helper'

describe TextNode do
  it "should be able to see that a double quoted string has a variable in it" do
    erb_file = ErbFile.from_string( '<%= "test #{"data"}" %>' )
    erb_file.nodes.size.should == 7
    erb_file.nodes[2].text_value == '"test '
    erb_file.nodes[3].text_value == '#{"data"}'
    erb_file.nodes[4].text_value == '"'
  end

  it "should be able to see that a string doesn't have a variable in it" do
    erb_file = ErbFile.from_string( 'test' )
    erb_file.nodes.size.should == 1
    erb_file.nodes.first.has_variables?.should == false
  end

  it "should not think that a regular string has variables" do
    erb_file = ErbFile.from_string( '"test #{"data"}"' )
    erb_file.nodes.size.should == 2
    erb_file.nodes[1].has_variables?.should == false
    
  end
  
  
  
end

