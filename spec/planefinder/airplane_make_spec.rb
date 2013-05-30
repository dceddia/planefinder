require 'spec_helper'

module Planefinder
  describe AirplaneMake do
    it "should be initializable with a JSON object and a category id" do
      json_make = JSON.parse(file_fixture('single_engine_makes.json')).first
      am = AirplaneMake.new(json_make, 42)
      am.count.should == 4
      am.id.should == 37
      am.name.should == "AMD"
      am.category_id.should == 42
    end

    it "should support ==" do
      json_make = JSON.parse(file_fixture('single_engine_makes.json')).first
      a = AirplaneMake.new(json_make, 5)
      b = AirplaneMake.new(json_make, 5)
      c = AirplaneMake.new(json_make, 6)
      a.should == b
      b.should_not == c
    end
  end
end
