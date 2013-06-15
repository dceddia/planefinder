require "csv"

module Geokit
  module Geocoders
    describe CityStateGeocoder do
      it "should return a LatLng when given a valid city, state" do
        loc = Geokit::Geocoders::CityStateGeocoder.geocode('Boston, MA')
        loc.class.should == LatLng
        loc.should be_valid
      end
=begin
      it "should return a LatLng for each city, state" do
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/state_latlon.csv")) do |row|
          state = row[0]
          lat = row[1]
          lng = row[2]
          Geokit::Geocoders::CityStateGeocoder.geocode(state).should == LatLng.new(lat, lng)
        end
      end
=end
      it "should return invalid LatLng for invalid combination" do
        Geokit::Geocoders::CityStateGeocoder.geocode('New York, MA').should_not be_valid
        Geokit::Geocoders::CityStateGeocoder.geocode('Boston, CA').should_not be_valid
        Geokit::Geocoders::CityStateGeocoder.geocode('Total Junk').should_not be_valid
      end

      it "should be way faster" do
        pending "create a database with a states_locations table and a city_state_locations table, then query it from the Geocoder(s)"
      end
    end
  end
end