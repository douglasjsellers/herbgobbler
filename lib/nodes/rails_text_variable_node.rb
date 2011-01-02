class RailsTextVariableNode
  include TextNode
  
  def initialize( key, value )
    @key = key
    @value = value
  end

  def text_value
    "%{#{@key}}"
  end

  def to_s
    ":#{@key} => (#{@value})"
  end
  
  
end

