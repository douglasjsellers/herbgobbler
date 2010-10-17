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

  it "should be able to serialize out two entries in the same context" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value" )
    store.add_translation( "key1", "value1" )
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "value"
    key1: "value1"
SIMPLE_KEY_VALUE
    store.serialize.should == resulting_string.strip
  end


  it "should be able to double nest contexts" do
    store = RailsTranslationStore.new
    store.start_new_context( "test/test2" )
    store.add_translation( "key", "value" )
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    test2:
      key: "value"
SIMPLE_KEY_VALUE

    store.serialize.should == resulting_string.strip
      
  end

  it "should be able to handle multiple keys with a double nested context" do
    store = RailsTranslationStore.new
    store.start_new_context( "test/test2" )
    store.add_translation( "key", "value" )
    store.add_translation( "key1", "value1" )
    
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    test2:
      key: "value"
      key1: "value1"
SIMPLE_KEY_VALUE

    store.serialize.should == resulting_string.strip    
  end

  it "should be able to handle very deep contexts" do
    store = RailsTranslationStore.new
    store.start_new_context( "test/test2/test3/test4/test5" )
    store.add_translation( "key", "value" )
    store.add_translation( "key1", "value1" )
    
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    test2:
      test3:
        test4:
          test5:
            key: "value"
            key1: "value1"
SIMPLE_KEY_VALUE
  end

  it "should be able to handle multiple contexts" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value" )
    store.start_new_context( "test2" )
    store.add_translation( "key", "value" )
    
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "value"
  test2:
    key: "value"

SIMPLE_KEY_VALUE
    store.serialize.should == resulting_string.strip
  end

  it "should be able to handle multiple contexts with multiple keys" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value" )
    store.add_translation( "key2", "value2" )
    store.start_new_context( "test2" )
    store.add_translation( "key", "value" )
    store.add_translation( "key3", "value3" )
    
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "value"
    key2: "value2"
  test2:
    key: "value"
    key3: "value3"
SIMPLE_KEY_VALUE
    store.serialize.should == resulting_string.strip
    
  end
  
  it "should escape keys that have double quotes in them" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", '"value"' )
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "\\"value\\""
SIMPLE_KEY_VALUE

    store.serialize.should == resulting_string.strip
    
  end
  
  
  
  
  
end
