require File.dirname(__FILE__) + '/../spec_helper'

describe I18nKey do
  it "should correctly generate keys in a normal situation" do
    text_call = I18nKey.new( "It was a cold and stormy night" )
    text_call.key_value.should == "it_was_a_cold"
  end

  it "should correctly generate a key that is short" do
    text_call = I18nKey.new( "It was" )
    text_call.key_value.should == "it_was"    
  end

  it "should cut the space off of the end of a sentence that ends in a space" do
    text_call = I18nKey.new( "It was " )
    text_call.key_value.should == "it_was"        
  end

  it "should cut the space off of the front of a sentence" do
    text_call = I18nKey.new( " It was" )
    text_call.key_value.should == "it_was"        
  end
  
  it "should remove extra spaces from a sentence" do
    text_call = I18nKey.new( "It   was   a  " )
    text_call.key_value.should == "it_was_a"
  end

  it "should remove the extra html tags" do
    text_call = I18nKey.new( ' Doug<a href="www.google">is great</a>yay!' )
    text_call.key_value.should == "doug_is_great"
  end

  it "should handle line breaks correctly" do
     text = <<TEXT
Doug
<a href="www.google.com">is great</a>
                                yay!
TEXT
    text_call = I18nKey.new( text )
    text_call.key_value.should == "doug_is_great"
  end

  it "should be able to eliminate the pipe character as a possible character" do
    text_call = I18nKey.new( "It|was " )
    text_call.key_value.should == "it_was"
  end
end

