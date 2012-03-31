class HerbErbTr8nTextCallNode < HerbTr8nTextCallNode

  def tr_call( html_end_tag = nil, count = 0 )
    if( empty? )
      ""
    else
      "<%= #{super(html_end_tag, count) } %>"
    end
  end
end
