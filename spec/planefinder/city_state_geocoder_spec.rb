require "csv"

module Geokit
  module Geocoders
    describe CityStateGeocoder do
      it "should return a LatLng when given a valid city, state" do
        loc = Geokit::Geocoders::CityStateGeocoder.geocode('Boston, MA')
        loc.class.should == LatLng
        loc.should be_valid
      end

      it "should return invalid LatLng for invalid combination" do
        Geokit::Geocoders::CityStateGeocoder.geocode('New York, MA').should_not be_valid
        Geokit::Geocoders::CityStateGeocoder.geocode('Boston, CA').should_not be_valid
        Geokit::Geocoders::CityStateGeocoder.geocode('Total Junk').should_not be_valid
      end
    end
  end
end