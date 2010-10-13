class RailsTranslationStore < BaseTranslationStore

  def initialize( language = "en" )
    super()
    @language = language
  end
  
  def serialize
    to_return = "#{@language}:\n"

    self.each do |context, key, value|
      to_return << "#{build_whitespace( 2 )}#{context}:\n"
      to_return << "#{build_whitespace( 4 )}#{key}: \"#{value}\""
    end
    
    to_return
  end

  private

  def build_whitespace( amount )
    " " * amount
  end
  
end
