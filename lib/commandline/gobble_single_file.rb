class GobbleSingleFile

  def initialize( rails_root, options )
    @rails_root = rails_root
    @options = options
  end

  def execute
    file_name = @options.first

    puts "Gobbling file: #{file_name}"
    puts ""
    
  end

  def valid?
    @options.size == 1
  end
  
end
