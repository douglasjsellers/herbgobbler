# This class is mostly responsible for all of the escaping that needs
# to occur for Tr8n to correctly understand the string.

class HerbTr8nStringNode

  ESCAPE_LOOKUP_TABLE = [
                         ["\"", "quot"],
                         ["\n", "break"],
                         ["&ndash;", "ndash"],
                         ["&mdash;", "mdash"],
                         ["&iexcl;", "iexcl"],
                         ["&iquest;", "iquest"],
                         ["&quot;", "quot"],
                         ["&ldquo;", "ldquo"],
                         ["&rdquo;", "rdquo"],
                         ["&lsquo;", "lsquo"],
                         ["&rsquo;", "rsquo"],
                         ["&laquo;", "laquo"],
                         ["&raquo;", "raquo"],
                         ["&nbsp;", "nbsp"]
                        ]

  def initialize( string )
    @escaped_string = tr8n_escape( string )
  end

  def text_value
    @escaped_string
  end

  def to_s
    text_value
  end

  private

  def replace_character( string, search_character, replace_character )
    string.gsub( search_character, "{#{replace_character}}" )
  end
  
  def tr8n_escape( string )
    ESCAPE_LOOKUP_TABLE.each do |lookup_pair|
      string = replace_character( string, lookup_pair.first, lookup_pair.last )
    end
    string
  end
  
  
end
