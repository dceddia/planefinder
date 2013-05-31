require 'spec_helper'

module Planefinder
  describe AirplaneListing do
    context "constructor" do
      it "should accept 1 argument: json" do
        json = JSON.parse(file_fixture('da40xl_airplanes.json')).first
        a = AirplaneListing.new(json)
      end
      
      it "should have some properties after initialization" do
        json = JSON.parse(file_fixture('da40xl_airplanes.json')).first
        a = AirplaneListing.new(json)
        a.model.should == "DA40XL"
        a.listing_id.should == "1581835"
        a.registration_number.should == "N866DS"
        a.total_time.should == "870"
        a.total_seats.should be_nil
        a.prop_4_time.should be_nil
      end
    end
  end
end