require 'backports'
require_relative '../spec_helper'

describe HerbNodeRetainingNode do
  it "should be able to correctly add up a lot of nodes and get the correct text value" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>" )
    nodes = erb_file.flatten_elements
    retaining_node = HerbNodeRetainingNode.new
    nodes.each do |node|
      retaining_node << node
    end
    retaining_node.text_value.should == '<%= doug is great %>'
  end

  it "should be able to correctly add up lots of node when the first node is passed into the constructor" do

    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>" )
    nodes = erb_file.flatten_elements
    first_node = nodes.first
    nodes = nodes[1..nodes.length]
    retaining_node = HerbNodeRetainingNode.new( first_node )
    nodes.each do |node|
      retaining_node << node
    end
    retaining_node.text_value.should == '<%= doug is great %>'
  end

  it "should be able to correctly add an array of nodes" do
    erb_file = ErbFile.from_string( "<%= \"doug is great\" %>" )
    nodes = erb_file.flatten_elements
    retaining_node = HerbNodeRetainingNode.new
    retaining_node << nodes
    retaining_node.text_value.should == '<%= doug is great %>'
  end

  it "should be able to return all of the sub nodes given to it" do
    node = HerbNodeRetainingNode.new
    node << HerbTextNode.new( "a" )
    node << HerbTextNode.new( "b" )

    node.nodes.size.should == 2
    node.nodes.first.text_value.should == "a"
    node.nodes.last.text_value.should == "b"
  end

  it "should be able to return all of the sub nodes given to it even when some of those sub nodes are herb node retaining nodes" do
    inner_node = HerbNodeRetainingTextNode.new
    inner_node << HerbTextNode.new( "a" )
    inner_node << HerbTextNode.new( "b" )

    outer_node = HerbNodeRetainingNode.new( inner_node )
    outer_node << HerbTextNode.new( "c" )

    outer_node.nodes.size.should == 3
    outer_node.nodes[0].text_value.should == "a"
    outer_node.nodes[1].text_value.should == "b"
    outer_node.nodes[2].text_value.should == "c"
  end
  
  
end
