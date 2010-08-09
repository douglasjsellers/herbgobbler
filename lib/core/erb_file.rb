class ErbFile
  def initialize( node_set )
    @node_set = flatten(node_set)
    
  end
  
  def compiled?
    !@node_set.nil?
  end

  def ErbFile.debug( file_path )
    Treetop.load( $ERB_GRAMMER_FILE )
    parser = ERBGrammerParser.new
    ErbFile.new( parser.parse( File.read( file_path ) ) )
    parser.failure_reason
  end
  
  def ErbFile.load( file_path )
    Treetop.load( $ERB_GRAMMER_FILE )
    parser = ERBGrammerParser.new
    ErbFile.new( parser.parse( File.read( file_path ) ) )
  end

  def to_s
    @node_set.to_s
  end
  

  private

  # This just goes through and get's rid of all of the heirarchy.
  # Being that the erb heirarchy is not actually that valuable to use
  def flatten( node_set )
    node_set
  end
  
end
