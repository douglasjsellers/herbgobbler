require File.dirname(__FILE__) + '/../spec_helper'
require 'yaml'
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
    yaml_result = YAML.load( store.serialize.strip )
    yaml_result.nil?.should == false
    yaml_result['en']['test']['key'].should == 'value'
    
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

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == 'value'
    yaml_result['en']['test']['key1'].should == 'value1'
    
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
    
    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['test2']['key'].should == 'value'
      
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

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['test2']['key'].should == 'value'
    yaml_result['en']['test']['test2']['key1'].should == 'value1'
    
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

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['test2']['test3']['test4']['test5']['key'].should == 'value'
    yaml_result['en']['test']['test2']['test3']['test4']['test5']['key1'].should == 'value1'
    
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

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == 'value'
    yaml_result['en']['test2']['key'].should == 'value'
    
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
    
    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == 'value'
    yaml_result['en']['test']['key2'].should == 'value2'
    yaml_result['en']['test2']['key'].should == 'value'
    yaml_result['en']['test2']['key3'].should == 'value3'
    
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

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == '"value"'
    
  end

  it "should correctly convert values with multilines into valid yml" do
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", "value\ndoug" )
    resulting_string =<<SIMPLE_KEY_VALUE
en:
  test:
    key: "value\\ndoug"
SIMPLE_KEY_VALUE

    store.serialize.should == resulting_string.strip
    
    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == "value\ndoug"


  end

  it "should escape indented multi-line strings correctly" do
    value_string =<<VALUE_STRING
                  <a href="jobs">jobs</a> | 
                  <a href="submit">submit</a>
VALUE_STRING
    
    store = RailsTranslationStore.new
    store.start_new_context( "test" )
    store.add_translation( "key", value_string )

    yaml_result = YAML.load( store.serialize )
    yaml_result.nil?.should == false    
    yaml_result['en']['test']['key'].should == value_string
    
  end

  it "should be able to load an existing yml file" do
    yaml_string =<<YAML_STRING
en:
  test:
    key: "value"
YAML_STRING

    store = RailsTranslationStore.load_from_string( yaml_string )
    yaml_result = YAML.load( store.serialize )    
    yaml_result['en']['test']['key'].should == 'value'
  end
  
end
