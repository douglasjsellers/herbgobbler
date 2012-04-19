class HerbTr8nLambdaCallNode

  attr_reader :original_text
  
  def initialize( original_text )
    @original_text = original_text
  end

  def generate_lambda( value )
    "lambda {|text| #{value}}"
  end
  
  def text_value
    '"#{text}"'
  end
  
end
