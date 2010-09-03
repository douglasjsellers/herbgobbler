require File.dirname(__FILE__) + '/../spec_helper'

class TestTextExtractor < TextExtractor
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
  
  def text( text_node )
    @text_found << text_node
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
    text_extractor.text_found.size.should == 1
    text_extractor.text_found.first.should == "Doug is great"
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

    nil_count = 0
    erb_file.nodes.each do |node|
      nil_count += 1 if node.nil?
    end
    nil_count.should == 2
  end
  
end
