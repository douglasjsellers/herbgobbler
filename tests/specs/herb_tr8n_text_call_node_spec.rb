require File.dirname(__FILE__) + '/../spec_helper'

describe HerbTr8nTextCallNode do
  it "should return empty? == true if nothing has been added to it" do
    node = HerbTr8nTextCallNode.new
    node.empty?.should == true
  end

  it "should render nothing if it is empty" do
    node = HerbTr8nTextCallNode.new
    node.to_s.should == ""
    node.text_value.should == ""
  end
  

end
