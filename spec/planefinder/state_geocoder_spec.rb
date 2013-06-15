require "csv"

module Geokit
  module Geocoders
    describe StateGeocoder do
      it "should return a LatLng when given a valid state" do
        loc = Geokit::Geocoders::StateGeocoder.geocode('MA')
        loc.class.should == LatLng
        loc.should be_valid
      end

      it "should return a LatLng for each state" do
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/state_latlon.csv")) do |row|
          state = row[0]
          lat = row[1]
          lng = row[2]
          Geokit::Geocoders::StateGeocoder.geocode(state).should == LatLng.new(lat, lng)
        end
      end

      it "should return invalid LatLng for invalid state or long state name" do
        Geokit::Geocoders::StateGeocoder.geocode('New York').should_not be_valid
        Geokit::Geocoders::StateGeocoder.geocode('XX').should_not be_valid
      end
    end
  end
end