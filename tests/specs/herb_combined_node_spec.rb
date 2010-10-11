require File.dirname(__FILE__) + '/../spec_helper'

class TestCombinedNode
  def initialize( node_value, node_type )
    @node_type = node_type
    @node_value = node_value
  end

  def node_name
    @node_type
  end

  def text_value
    @node_value
  end

  def text?
    self.node_name == 'text'
  end
  
  def to_s
    text_value
  end
  
end

describe HerbCombinedNode do

  it "should be able to determine if two text nodes are the text" do
    node = HerbCombinedNode.new( TestCombinedNode.new( "abc", "text" ), TestCombinedNode.new( "123", "text" ) )
    node.text?.should == true
  end

  it "should be be able to determine if two html nodes are combined that it is not text" do
    node = HerbCombinedNode.new( TestCombinedNode.new( "<br/>", "html_self_contained" ), TestCombinedNode.new( "<br/>", "html_self_contained" ) )
    node.text?.should == false
  end

  it "should be able to determine that an html node and a text node are in fact text" do
    node = HerbCombinedNode.new( TestCombinedNode.new( "abc", "text" ), TestCombinedNode.new( "<br/>", "html_self_contained" ) )
    node.text?.should == true
    
  end
  
end
