require 'backports'
require_relative '../spec_helper'

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
    text_call.key_value.should == "doug_is_great_html"
  end

  it "should handle line breaks correctly" do
     text = <<TEXT
Doug
<a href="www.google.com">is great</a>
                                yay!
TEXT
    text_call = I18nKey.new( text )
    text_call.key_value.should == "doug_is_great_html"
  end

  it "should be able to eliminate the pipe character as a possible character" do
    text_call = I18nKey.new( "It|was " )
    text_call.key_value.should == "it_was"
  end

  it "should not generate duplicate key names when a valid keystore is passed in" do
    key_store = []
    key_1 = I18nKey.new( "key", key_store )
    key_2 = I18nKey.new( "key", key_store )
    key_3 = I18nKey.new( "key", key_store )

    key_1.key_value.should == "key"
    key_2.key_value.should == "key_1"
    key_3.key_value.should == "key_2"
    
  end

  it "should remove %{} blocks that are common in rails i18n" do
    text_call = I18nKey.new( "doug %{count}" )
    text_call.key_value.should == "doug"    
  end

  it "should not eliminate double characters" do
    text_call = I18nKey.new( "A GOOD whiteboard" )
    text_call.key_value.should == "a_good"
  end

  it "should be able to eliminate all of the bad characters and still return a value" do
    text_call = I18nKey.new( "%{link_to_last} &nbsp; %{link_to_last_1} &nbsp; %{link_to_last_2}" )
    text_call.key_value.should == "nbsp_nbsp"
  end

  it "should return a default key if a blank key should have been generated" do
    text_call = I18nKey.new( "%{link_to_last}" )
    text_call.key_value.should == "key"
    
  end
  
  
  
end

