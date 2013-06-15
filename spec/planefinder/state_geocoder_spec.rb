require "csv"

module Geokit
  module Geocoders
    describe StateGeocoder do
      it "should return a LatLng when given a valid state" do
        Geokit::Geocoders::StateGeocoder.geocode('MA').class.should == LatLng
      end

      it "should return a LatLng for each state" do
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/state_latlon.csv")) do |row|
          state = row[0]
          lat = row[1]
          lng = row[2]
          Geokit::Geocoders::StateGeocoder.geocode(state).should == LatLng.new(lat, lng)
        end
      end
    end
  end
end