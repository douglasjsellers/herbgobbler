require File.dirname(__FILE__) + '/../spec_helper'

describe RailsTranslationStore do
  it "should be able to add a context, value, and interate over it" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value" )

    store.each do |context, key, value|
      context.should == "test"
      key.should == "key"
      value.should == "value"
    end
  end


  it "should be able to serialize out a simple language, key and value" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value" )
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "value"
SIMPLE_KEY_VALUE

    store.serialize.should == resulting_string.strip
  end
  
end
