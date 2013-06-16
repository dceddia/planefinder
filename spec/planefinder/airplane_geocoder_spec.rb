require "csv"

module Geokit
  module Geocoders
    describe AirplaneGeocoder do
      it "should return a LatLng when given a valid city, state" do
        loc = Geokit::Geocoders::AirplaneGeocoder.geocode('Boston, MA')
        loc.class.should == LatLng
        loc.should be_valid
      end

      it "should return invalid LatLng for invalid city, state combinations" do
        Geokit::Geocoders::AirplaneGeocoder.geocode('New York, MA').should_not be_valid
        Geokit::Geocoders::AirplaneGeocoder.geocode('Boston, CA').should_not be_valid
        Geokit::Geocoders::AirplaneGeocoder.geocode('Total Junk').should_not be_valid
      end

      it "should return a LatLng when given a valid state" do
        loc = Geokit::Geocoders::AirplaneGeocoder.geocode('MA')
        loc.class.should == LatLng
        loc.should be_valid
      end

      it "should return a LatLng for each state" do
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/state_latlon.csv"), :headers => true) do |row|
          state = row[0]
          lat = row[1]
          lng = row[2]
          Geokit::Geocoders::AirplaneGeocoder.geocode(state).should == LatLng.new(lat, lng)
        end
      end

      it "should return invalid LatLng for invalid state or long state name" do
        Geokit::Geocoders::AirplaneGeocoder.geocode('New York').should_not be_valid
        Geokit::Geocoders::AirplaneGeocoder.geocode('XX').should_not be_valid
      end

      it "should return a LatLng for a zip code" do
        loc = Geokit::Geocoders::AirplaneGeocoder.geocode("90210")
        loc.class.should == LatLng
        loc.should be_valid
      end

      it "should return an invalid LatLng for invalid zipcode" do
        Geokit::Geocoders::AirplaneGeocoder.geocode("99999").should_not be_valid
        Geokit::Geocoders::AirplaneGeocoder.geocode("90210-1234").should_not be_valid
        Geokit::Geocoders::AirplaneGeocoder.geocode("9021").should_not be_valid
      end

      it "should return a LatLng for a phone number" do
        Geokit::Geocoders::AirplaneGeocoder.geocode("9785551212").should be_valid
      end

      it "should return an invalid LatLng for phone number with bad area code" do
        Geokit::Geocoders::AirplaneGeocoder.geocode("9115551212").should_not be_valid
      end

      context "sanitize_phone" do
        it "should sanitize phone numbers to be 10 digits" do
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('9785551212').should == '9785551212'
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('978-555-1212').should == '9785551212'
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('978.555.1212').should == '9785551212'
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('(978)555-1212').should == '9785551212'
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('(978) 555-1212').should == '9785551212'
          Geokit::Geocoders::AirplaneGeocoder.sanitize_phone('+1 978-555-1212').should == '9785551212'
        end
      end

      context "us_phone_number?" do
        it "should return true if the argument looks like a phone number" do
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('9785551212').should be_true
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('978-555-1212').should be_true
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('978.555.1212').should be_true
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('(978)555-1212').should be_true
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('(978) 555-1212').should be_true
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('+1 978-555-1212').should be_true

        end

        it "should return false if the argument does not look like a phone number" do
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('978555121').should be_false
          Geokit::Geocoders::AirplaneGeocoder.us_phone_number?('words').should be_false
        end
      end
    end
  end
end