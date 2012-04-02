require 'backports'
require_relative '../spec_helper'

describe HerbStringVariable do

  it "should be able to extract a variable from a double quoted string" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"}" %>' )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    
    nodes.size.should == 1
    nodes.first.is_a?( HerbNodeRetainingTextNode )
    nodes.first.nodes.size.should == 6
    nodes.first.nodes[3].is_a?(HerbStringVariable).should == true
  end

  it "should be able to extract multiple values from a double quoted string" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"} #{"!"}" %>' )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    
    nodes.size.should == 1
    nodes.first.is_a?( HerbNodeRetainingTextNode )
    nodes.first.nodes.size.should == 8
    nodes.first.nodes[3].is_a?(HerbStringVariable).should == true
    nodes.first.nodes[5].is_a?(HerbStringVariable).should == true
    
  end
  
end

