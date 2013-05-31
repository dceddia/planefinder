require 'spec_helper'

module Planefinder
  describe AirplaneMake do
    let(:json_make) { JSON.parse(file_fixture('single_engine_makes.json')).select{ |m| m['name'] == 'Diamond' }.first }
    
    it "should be initializable with a JSON object and a category id" do
      am = AirplaneMake.new(json_make, 1)
      am.count.should == 13
      am.id.should == 155
      am.name.should == "Diamond"
      am.category_id.should == 1
    end

    it "should support ==" do
      a = AirplaneMake.new(json_make, 5)
      b = AirplaneMake.new(json_make, 5)
      c = AirplaneMake.new(json_make, 6)
      a.should == b
      b.should_not == c
    end
    
    it "should be able to fetch models for its make" do
      am = AirplaneMake.new(json_make, 1)
      models = am.get_models
      models.each { |m| m.make_id.should == am.id }
    end
  end
end
