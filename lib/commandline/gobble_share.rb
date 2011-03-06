module GobbleShare
  # remove the file extension and the app/views/ so that
  # when the context is set that rails will be able to find
  # it through the default . key syntax
  def convert_path_to_key_path( path )
    path.split('.').first.gsub( '/app/views/', '')
  end
  
end
