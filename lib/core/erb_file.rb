class ErbFile
  def initialize( node_set )
    @node_set = node_set
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
