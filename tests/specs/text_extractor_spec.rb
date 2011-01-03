require File.dirname(__FILE__) + '/../spec_helper'

class TestTextExtractor < BaseTextExtractor
  attr_accessor :found_start_text_extraction
  attr_accessor :found_completed_text_extraction
  attr_accessor :text_found
  attr_accessor :variables_found
  attr_accessor :non_text_found
  
  def initialize
    @found_completed_text_extraction = false
    @found_start_text_extraction = false
    @text_found = []
    @non_text_found = []
    @variables_found = []
    @nodes = []
  end
  
  def starting_text_extraction
    @found_start_text_extraction = true
  end
  
  def add_html_text( text_node )
    @text_found << text_node.text_value
    @nodes << text_node
  end

  def add_non_text( node )
    @non_text_found << node
  end
  
  def end_html_text
    @nodes
  end
  
  def start_html_text
  end

  def add_variable( variable_name, variable_value)
    @variables_found << [variable_name, variable_value]
  end
  
  def white_space( node )
    @nodes << node
  end
  

  # This is called when text extraction has finished
  def completed_text_extraction
    @found_completed_text_extraction = true
  end  
end

describe TextExtractor do
  it "should be able to mark things as started and completed" do
    erb_file = ErbFile.from_string( "<div>Doug is great</div>" )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.found_completed_text_extraction.should == true
    text_extractor.found_start_text_extraction.should == true
  end

  it "should be able to perform very simple text extraction from an html element" do
    erb_file = ErbFile.from_string( "<div>Doug is great</div>" )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 1
    text_extractor.text_found.first.should == "Doug is great"
  end


  it "should be able to remove extra white space from around text" do
    html_text = "<div>
        Doug is great
</div>"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.text_found.size.should == 1
    text_extractor.text_found[0].should == "Doug is great"
    
  end

  it "should be able to extract multiple pieces of text" do
    html_text = "<div>Doug is</div>Great"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 2
    text_extractor.text_found.first.should == "Doug is"
    text_extractor.text_found.last.should == "Great"
  end

  it "should replace the text nodes in the original erb file" do
    html_text = "<div>Doug is</div>Great"
    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )

    text_extractor.text_found.size.should == 2

    erb_file.nodes.size == 0
  end

  it "should return only whitespace nodes" do
    html_text = "<b>
</b>"

    erb_file = ErbFile.from_string( html_text )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    
    text_extractor.text_found.size.should == 0

  end

  it "should successfully extract text strings contained within an erb string block" do
    erb_file = ErbFile.from_string( 'test<%= "!" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.text_found.size.should == 2
    text_extractor.text_found[0].should == "test"
    text_extractor.text_found[1].should == "!"
  end

  it "should discard the <%= and the %> around everything when extracting text" do
    erb_file = ErbFile.from_string( 'test<%="!"%>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.non_text_found.empty?.should == true
  end

  it "should discard the <%= and the %> and the white space around everything when extracting text" do
    erb_file = ErbFile.from_string( 'test<%= "!" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.non_text_found.empty?.should == true
  end

  it "should extract a string variable and report the text before it as regular text" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"}" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.text_found.size.should == 1
    text_extractor.text_found.first.should == "doug is "
  end

  it "should extract a string variable and report the variable using add variable" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"}" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.variables_found.size.should == 1
    text_extractor.variables_found.first.last.should == "\"great\""
  end

  it "should extract multiple variables and report them back using add_variable" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"} #{"!"}" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.variables_found.size.should == 2
    text_extractor.variables_found.first.last.should == "\"great\""
    text_extractor.variables_found.last.last.should == "\"!\""
  end
  
  it "should extract a single variable and report back a reasonably named key" do
    erb_file = ErbFile.from_string( '<%= "doug is #{"great"}" %>' )
    text_extractor = TestTextExtractor.new
    erb_file.extract_text( text_extractor )
    text_extractor.variables_found.size.should == 1
    text_extractor.variables_found.first.first.should == "great"
    
  end
  
  
end
