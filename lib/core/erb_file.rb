class ErbFile
  
  attr_accessor :nodes
  def initialize( node_set )
    @node_set = node_set
    @nodes = accumulate_top_levels if compiled?
    @debug = false
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

  
  def combine_nodes( node_list )
    to_return = []
    @nodes.each do |node|
      puts "Node: #{node.node_name} = #{can_be_combined?( node )}" if @debug      
      if( can_be_combined?( node ) )
        if( !to_return.empty? && can_be_combined?( to_return.last) )
          to_return << ( HerbCombinedNode.new( to_return.pop, node ) )
        else
          to_return << node
        end
      else
        if( last_node_should_be_unrolled?( to_return.last ) )
          last_combined_node = to_return.pop
          to_return += last_combined_node.unroll
        end        
        to_return << node
      end
    end
    to_return
  end

  

  def extract_text( text_extractor )
    # 1.  Going to have to loop over all of the elements and find all of
    # the text.
    # 2.  Then make the call back to the text_extractor
    # 3.  Finally replace the nodes in the top levels (not sure how
    # this is going to work with any of the nested stuff)
    text_extractor.starting_text_extraction
    new_node_set = []
    @nodes = combine_nodes( @nodes )    
    @nodes.each do |node|      
      if( node.text? )
        returned_nodes = text_extractor.html_text( node )
        new_node_set += returned_nodes unless returned_nodes.nil?
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

  def serialize
    to_return = ""
    nodes.each do |node|
      to_return << node.text_value
    end

    to_return
  end
  
  
  def to_s
    to_return = ""
    nodes.each do |node|
      to_return += node.text_value
    end
    to_return
  end
  
  private

  def ErbFile.parse( data_to_parse )
    Treetop.load( $ERB_GRAMMER_FILE )
    @parser = ERBGrammerParser.new
    ErbFile.new( @parser.parse( data_to_parse ) )
  end

  def last_node_should_be_unrolled?( last_node )
    !last_node.nil? && last_node.node_name == "herb_combined_nodes" && last_node.should_be_unrolled?  
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

  def can_be_combined?( node )
    (node.respond_to? :can_be_combined?) && node.can_be_combined?    
  end
  
end
