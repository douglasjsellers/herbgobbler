class ErbFile
  def initialize( node_set )
    @node_set = node_set
  end

  def ErbFile.load( file_path )
    Treetop.load( $ERB_GRAMMER_FILE )
    parser = ERBGrammerParser.new
    ErbFile.new( parser.parse( File.read( file_path ) ) )
  end

  def ErbFile.debug( file_path )
    Treetop.load( $ERB_GRAMMER_FILE )
    parser = ERBGrammerParser.new
    ErbFile.new( parser.parse( File.read( file_path ) ) )
    parser.failure_reason
  end
  
  def compiled?
    !@node_set.nil?
  end
  
end
