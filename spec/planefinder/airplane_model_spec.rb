require 'spec_helper'

module Planefinder
  describe AirplaneModel do
    let(:diamond_models) { JSON.parse(file_fixture('diamond_models.json')) }
    let(:da40) { diamond_models.select { |m| m['name'] == "DA40" }.first }
    let(:da40xls) { diamond_models.select { |m| m['name'] == "DA40 XLS" }.first }
    
    describe "constructor" do
      it "should take 3 arguments: json, category, make" do
        am = AirplaneModel.new(da40, double(AirplaneCategory), double(AirplaneMake))
      end
      
      it "should have appropriate values after creation" do
        cat = double(AirplaneCategory)
        make = double(AirplaneMake)
        am = AirplaneModel.new(da40, cat, make)
        am.name.should == "DA40"
        am.model_group.should == "DA40 Series"
        am.id.should == 4140
        am.count.should == 5
        am.category.should == cat
        am.make.should == make
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
      make = double(Planefinder::AirplaneMake, :name => "Diamond")
      cat = double(Planefinder::AirplaneCategory, :name => "Single Engine Piston")
      am = AirplaneModel.new(da40, cat, make)
      listing = AirplaneListing.new({})
      Planefinder.stub(:search_by_model_make_category).and_return([listing])
      Planefinder.should_receive(:search_by_model_make_category).with(am, make, cat)

      listings = am.get_listings
      listings.first.should == listing
    end
  end
end