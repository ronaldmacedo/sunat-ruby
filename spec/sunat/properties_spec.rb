require 'spec_helper'

describe SUNAT::Properties do
  
  before :all do
    @aux_model = Class.new do
      include SUNAT::Model
      property :age, Fixnum
    end
    Kernel.const_set("Aux", @aux_model)
  end

  before :each do
    @model = Class.new do
      include SUNAT::Model
      property :name, String
    end
    
    @obj = @model.new
  end


  describe "#get_attribute" do
    it "should provide object in model" do
      @obj[:key1] = 'value'
      @obj.get_attribute(:key1).should eql('value')
    end
  end

  describe "#set_attribute" do
    it "should be posible to set attribute not defined as property" do
      @obj.set_attribute('key1', 'value1')
      @obj.set_attribute(:key2, 'value2')
      @obj[:key1].should eql('value1')
      @obj[:key2].should eql('value2')
    end

    it "should set and cast attribute with property" do
      property = @model.send(:properties)[:name]
      name = "Fred Flinstone"
      property.should_receive(:cast).with(@obj, name).and_return(name)
      @obj.set_attribute(:name, name)
      @obj[:name].should eql(name)
    end
  end

  describe ".properties" do

    it "should be instantiated after property set" do
      @model.properties.should_not be_nil
      @model.properties.class.should eql(Hash)
    end

    it "should be null if no properties" do
      model = Class.new do
        include SUNAT::Model
      end
      model.properties.should be_nil
    end

  end

  describe ".property" do

    it "should fail if no type is defined" do
      @model.properties.length.should eql(1)
      expect {
        @model.property :foobar
      }.to raise_error(ArgumentError)
      @model.properties.length.should eql(1)
    end

    it "should create a new property with helper methods" do
      @model.properties.length.should eql(1)
      @model.property :desc, String
      @model.properties.length.should eql(2)

      prop = @model.properties[:desc]
      prop.class.should eql(SUNAT::Property)

      @obj.should respond_to(:desc)
      @obj.should respond_to(:desc=)

      @obj.desc = "test"
      @obj.desc.should eql("test")
    end
    
    it "should return nil on property with no default" do
      @model.property :nickname, String
      @obj.nickname.should be_nil
    end

    it "should create helper method with support for default values" do
      @model.property :name, String, :default => "Sam"
      @obj.name.should eql("Sam")
    end

  end


end
