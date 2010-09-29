require File.dirname(__FILE__) + '/../spec_helper'

describe HerbErbTextCallNode do
  it "should be able to return a simple text value" do
    node = HerbErbTextCallNode.new( ['the quick brown fox jumps over'] )
    node.original_text.should == 'the quick brown fox jumps over'
  end

  it "should be able to return mutiple pieces of the original text value" do
    node = HerbErbTextCallNode.new( ['the quick brown fox jumps over ', 'the hedge'] )
    node.original_text.should == 'the quick brown fox jumps over the hedge'
  end
  
  it "should be able to generate a simple key" do
    node = HerbErbTextCallNode.new( ['the quick brown fox jumps over'] )
    node.key_value.should == 'the_quick'
  end

  it "should be able to correctly prepend data" do
    node = HerbErbTextCallNode.new( ['the quick brown fox jumps over'], 't :' )
    node.text_value.should == '<%= t :the_quick %>'
  end

  it "should be able to correctly postpend data" do
    node = HerbErbTextCallNode.new( ['the quick brown fox jumps over'], '"', '"' )
    node.text_value.should == '<%= "the_quick" %>'
  end  
end

