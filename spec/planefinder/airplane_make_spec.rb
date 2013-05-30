require 'spec_helper'

module Planefinder
  describe AirplaneMake do
    it "should be initializable with a JSON object" do
      json_make = JSON.parse(file_fixture('single_engine_makes.json')).first
      am = AirplaneMake.new(json_make)
      am.count.should == 4
      am.id.should == 37
      am.name.should == "AMD"
    end

    it "should support ==" do
      json_make = JSON.parse(file_fixture('single_engine_makes.json')).first
      a = AirplaneMake.new(json_make)
      b = AirplaneMake.new(json_make)

      a.should == b
    end
  end
end
