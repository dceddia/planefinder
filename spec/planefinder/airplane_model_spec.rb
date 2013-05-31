require 'spec_helper'

module Planefinder
  describe AirplaneModel do
    describe "constructor" do
      it "should take 3 arguments: json, category_id, make_id" do
        json_model = JSON.parse(file_fixture('diamond_models.json')).first
        am = AirplaneModel.new(json_model, 1, 155)
      end
      
      it "should have appropriate values after creation" do
        json_model = JSON.parse(file_fixture('diamond_models.json')).select { |m| m['name'] == "DA40" }.first
        am = AirplaneModel.new(json_model, 1, 155)
        am.name.should == "DA40"
        am.model_group.should == "DA40 Series"
        am.id.should == 4140
        am.count.should == 5
        am.category_id.should == 1
        am.make_id.should == 155
      end
    end
    
    it "should support ==" do
      diamond_models = JSON.parse(file_fixture('diamond_models.json'))
      da40 = diamond_models.select { |m| m['name'] == 'DA40' }.first
      da40xls = diamond_models.select { |m| m['name'] == 'DA40 XLS' }.first
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
  end
end