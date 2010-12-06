require File.dirname(__FILE__) + '/../spec_helper'

class TestTextNode
  attr_accessor :text_value
  def initialize( string )
    @text_value = string
  end
end

describe BaseTextExtractor do
  it "should remove all of the whitespace from the front of the node and add it as a separate node before the actual text" do
    string = "     abc";
    result = "     ";

    extractor = BaseTextExtractor.new
    results = extractor.html_text( TestTextNode.new( string ) )
    results.first.text_value.should == result
    results.last.text_value.should == string.lstrip
  end

  it "should remove all of the whitespace from the rear of the node and add it as a separate node after the actual text" do
    result = "     ";    
    string = "abc" + result;
    extractor = BaseTextExtractor.new
    results = extractor.html_text( TestTextNode.new( string ) )
    results.first.text_value.should == string.rstrip    
    results.last.text_value.should == result
  end

  it "should remove all of the whitespace from both the front and the rear of a text node and attach separate nodes on either side of text to represent the whitespace" do
    front_ws = "   "
    rear_ws = "        "
    string = front_ws + "abc" + rear_ws
    extractor = BaseTextExtractor.new
    results = extractor.html_text( TestTextNode.new( string ) )
    results.first.text_value.should == front_ws
    results[1].text_value.should == "abc"
    results.last.text_value.should == rear_ws
    
  end

  it "should be able to handle spacing around multiple lines" do
    rear_ws = "    "
    string = "abc\n       123" + rear_ws
    extractor = BaseTextExtractor.new
    results = extractor.html_text( TestTextNode.new( string ) )
    results.first.text_value.should ==  "abc\n       123"
    results.last.text_value == rear_ws
  end
  
  
  
end
