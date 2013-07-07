require 'spec_helper'

module Planefinder
  describe AirplaneMake do
    let(:json_make) { JSON.parse(file_fixture('single_engine_makes.json')).select{ |m| m['name'] == 'Diamond' }.first }
    
    it "should be initializable with a JSON object and a category" do
      category = double(AirplaneCategory)
      am = AirplaneMake.new(json_make, category)
      am.count.should == 13
      am.id.should == 155
      am.name.should == "Diamond"
      am.category.should == category
    end

    it "should support ==" do
      a = AirplaneMake.new(json_make, 5)
      b = AirplaneMake.new(json_make, 5)
      c = AirplaneMake.new(json_make, 6)
      a.should == b
      b.should_not == c
    end
    
    it "should be able to fetch models for its make" do
      models = [1, 2, 3]
      category = double(AirplaneCategory)
      am = AirplaneMake.new(json_make, category)
      Planefinder.should_receive(:get_models_for_category_and_make).with(category, am) { models }
      am.get_models.should == models
    end
  end
end
