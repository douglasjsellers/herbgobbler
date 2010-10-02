require File.dirname(__FILE__) + '/../spec_helper'

class TestTextExtractor < BaseTextExtractor
  attr_accessor :found_start_text_extraction
  attr_accessor :found_completed_text_extraction
  attr_accessor :text_found

  def initialize
    @found_completed_text_extraction = false
    @found_start_text_extraction = false
    @text_found = []
  end
  
  def starting_text_extraction
    @found_start_text_extraction = true
  end
  
  def html_text( text_node )
    # I must not understand how this works
    super( text_node ).each do |node|
      @text_found << node.text_value
    end
    
    nil
  end


  # This is called when text extraction has finished
  def completed_text_extraction
    @found_completed_text_extraction = true
  end  
end

describe TextExtractor do
  it "should be able to mark things as started and completed" do
    erb_file = ErbFile.from_string( "<b>Doug is great</b>" )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.found_completed_text_extraction.should == true
    text_extractor.found_start_text_extraction.should == true
  end

  it "should be able to perform very simple text extraction from an html element" do
    erb_file = ErbFile.from_string( "<b>Doug is great</b>" )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 1
    text_extractor.text_found.first.should == "Doug is great"
  end


  it "should be able to remove extra white space from around text" do
    html_text = "<b>
        Doug is great
</b>"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )    
    text_extractor.text_found.size.should == 3
    text_extractor.text_found.first.should == "\n        "
    text_extractor.text_found[1].should == "Doug is great"
    text_extractor.text_found.last.should == "\n"
    
  end

  it "should be able to extract multiple pieces of text" do
    html_text = "<b>Doug is</b>Great"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 2
    text_extractor.text_found.first.should == "Doug is"
    text_extractor.text_found.last.should == "Great"
  end

  it "should replace the text nodes in the original erb file" do
    html_text = "<b>Doug is</b>Great"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 2

    erb_file.nodes.size == 0
  end
  
end
