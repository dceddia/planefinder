require 'spec_helper'

module Planefinder
  describe AirplaneCategory do
    let(:json_categories) { JSON.parse(file_fixture('airplane_categories.json')) } 

    it "should be initializable with a JSON category description" do
      ac = AirplaneCategory.new(json_categories.first)
      ac.count.should == 2429
      ac.id.should == 1
      ac.name.should == "Single Engine Piston"
      ac.sort_priority.should == 1
    end

    it "should throw an error with an invalid category" do
      special = json_categories.select { |c| c.has_key?('special_use_counts') }
      expect { AirplaneCategory.new(special) }.to raise_error
    end

    it "should support ==" do
      a = AirplaneCategory.new(json_categories.first)
      b = AirplaneCategory.new(json_categories.first)

      a.should == b
    end
    
    it "should be able to fetch makes for its category" do
      ac = AirplaneCategory.new(json_categories.first)
      makes = [1, 2, 3]
      Planefinder.stub(:get_makes_for_category) { makes }
      ac.get_makes.should == makes
    end
  end
end
