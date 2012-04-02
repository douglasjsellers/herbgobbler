require 'backports'
require_relative '../spec_helper'

describe HerbTr8nStringNode do

  it "should escape quotes character" do
    s = "please escape \" this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {quot} this character"
    
  end

  it "should escape new line character" do
    s = "please escape \n this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {break} this character"
    
  end

  it "should escape two \n characters in a row" do
    s = "please escape \n\n this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {break}{break} this character"
    
  end

  it "should escape \n characters book ending a string" do
    s = "\nplease escape this character\n"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "{break}please escape this character{break}"
  end
  
  
  it "should escape ndash" do
    s = "please escape &ndash; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {ndash} this character"
    
  end


  it "should escape mdash" do
    s = "please escape &mdash; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {mdash} this character"
    
  end

  it "should escape iexcl" do
    s = "please escape &iexcl; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {iexcl} this character"
    
  end

  it "should escape iquest" do
    s = "please escape &iquest; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {iquest} this character"
    
  end

  it "should escape quot" do
    s = "please escape &quot; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {quot} this character"
    
  end

  it "should escape ldquo" do
    s = "please escape &ldquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {ldquo} this character"
    
  end

  it "should escape rdquo" do
    s = "please escape &rdquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {rdquo} this character"
    
  end

  it "should escape lsquo" do
    s = "please escape &lsquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {lsquo} this character"
    
  end

  it "should escape rsquo" do
    s = "please escape &rsquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {rsquo} this character"
    
  end

  it "should escape laquo" do
    s = "please escape &laquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {laquo} this character"
    
  end

  it "should escape raquo" do
    s = "please escape &raquo; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {raquo} this character"
    
  end

  it "should escape nbsp" do
    s = "please escape &nbsp; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {nbsp} this character"
    
  end

  it "should escape all special characters" do
    s = "please escape \n &ndash; &mdash; &iexcl; &iquest; &quot; &ldquo; &rdquo; &lsquo; &rsquo; &laquo; &raquo; &nbsp; this character"
    string_node = HerbTr8nStringNode.new( s )
    string_node.text_value.should == "please escape {break} {ndash} {mdash} {iexcl} {iquest} {quot} {ldquo} {rdquo} {lsquo} {rsquo} {laquo} {raquo} {nbsp} this character"
    
  end
  
end

