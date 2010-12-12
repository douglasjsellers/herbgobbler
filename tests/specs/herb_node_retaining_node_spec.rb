require File.dirname(__FILE__) + '/../spec_helper'

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
  
  
end
