class ErbFile
  
  attr_accessor :nodes
  def initialize( node_set )
    @node_set = node_set
    @nodes = accumulate_top_levels if compiled?
  end

  def accumulate_top_levels
    terminals = []
    process_element_for_top_levels( @node_set, terminals )    
  end
  
  def compiled?
    !@node_set.nil?
  end

  def ErbFile.debug( file_path )
    ErbFile.parse( File.read( file_path ) )
    @parser.failure_reason
  end

  def extract_text( text_extractor )
    # 1.  Going to have to loop over all of the elements and find all of
    # the text.
    # 2.  Then make the call back to the text_extractor
    # 3.  Finally replace the nodes in the top levels (not sure how
    # this is going to work with any of the nested stuff)
    text_extractor.starting_text_extraction
    new_node_set = []
    @nodes.each do |node|
      if( node.text? )
        node_string = node.text_value.strip
        new_node_set << text_extractor.html_text( node_string )        
      else
        new_node_set << node
      end
      @nodes = new_node_set
      self
    end
    
    text_extractor.completed_text_extraction
  end
  
  def ErbFile.from_string( string_to_parse )
    ErbFile.parse( string_to_parse )
  end
  
  def ErbFile.load( file_path )
    ErbFile.parse( File.read( file_path ) )
  end

  
  def to_s
    @node_set.inspect
  end
  
  private

  def ErbFile.parse( data_to_parse )
    Treetop.load( $ERB_GRAMMER_FILE )
    @parser = ERBGrammerParser.new
    ErbFile.new( @parser.parse( data_to_parse ) )
  end

  def process_element_for_top_levels( element, terminals )
    if element.respond_to?( 'top_level?' ) && element.top_level?
      terminals << element
    elsif( !element.terminal? )
      element.elements.each do |new_element|
        process_element_for_top_levels( new_element, terminals )
      end
    end
    terminals
  end
  
end
