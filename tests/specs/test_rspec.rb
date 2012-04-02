require 'backports'
require_relative '../spec_helper'

describe String do
  it "should return the correct size of a string" do
    "abc".size.should == 3
  end
end

  
