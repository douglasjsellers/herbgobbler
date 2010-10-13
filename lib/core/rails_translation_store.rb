class RailsTranslationStore < BaseTranslationStore

  def initialize( language = "en" )
    super()
    @language = language
  end
  
  def serialize
    to_return = "#{@language}:\n"
    last_context = nil
    self.each do |context, key, value|
      to_return << "#{build_whitespace( 2 )}#{context}:\n" unless context == last_context
      to_return << "#{build_whitespace( 4 )}#{key}: \"#{value}\"\n"
      last_context = context
    end
    
    to_return.chomp
  end

  private

  def build_whitespace( amount )
    " " * amount
  end
  
end
