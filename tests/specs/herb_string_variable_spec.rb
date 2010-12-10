require File.dirname(__FILE__) + '/../spec_helper'

describe HerbStringVariable do

  it "should be able to extract a variable from a double quoted string" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"}" %>' )
    nodes = erb_file.combine_nodes( erb_file.nodes )

    nodes.size.should == 5
    nodes[2].is_a?(HerbStringVariable).should == true
  end
  
end

