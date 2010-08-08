class NonTextNode < Treetop::Runtime::SyntaxNode
  def text?
    true
  end
end
