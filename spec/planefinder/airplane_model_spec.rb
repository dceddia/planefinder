require 'spec_helper'

module Planefinder
  describe AirplaneModel do
    let(:diamond_models) { JSON.parse(file_fixture('diamond_models.json')) }
    let(:da40) { diamond_models.select { |m| m['name'] == "DA40" }.first }
    let(:da40xls) { diamond_models.select { |m| m['name'] == "DA40 XLS" }.first }
    
    describe "constructor" do
      it "should take 3 arguments: json, category_id, make_id" do
        am = AirplaneModel.new(da40, 1, 155)
      end
      
      it "should have appropriate values after creation" do
        am = AirplaneModel.new(da40, 1, 155)
        am.name.should == "DA40"
        am.model_group.should == "DA40 Series"
        am.id.should == 4140
        am.count.should == 5
        am.category_id.should == 1
        am.make_id.should == 155
      end
    end
    
    it "should support ==" do
      a = AirplaneModel.new(da40, 1, 155)
      b = AirplaneModel.new(da40, 1, 155)
      c = AirplaneModel.new(da40xls, 1, 155)
      d = AirplaneModel.new(da40xls, 2, 155)
      e = AirplaneModel.new(da40xls, 2, 400)
      
      a.should == b
      b.should == a
      a.should_not == c
      b.should_not == c
      c.should_not == d
      d.should_not == e
    end
    
    it "should be able to retrieve listings" do
      am = AirplaneModel.new(da40, 1, 155)
      pending "pass the string versions of model, category, and make to search_by..."
    end
  end
end