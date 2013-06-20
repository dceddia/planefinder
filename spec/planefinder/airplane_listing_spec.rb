require 'spec_helper'

module Planefinder
  describe AirplaneListing do
    context "constructor" do
      it "should accept 1 argument: json" do
        listing_hash = JSON.parse(file_fixture('da40xl_airplanes.json')).first
        a = AirplaneListing.new(listing_hash)
      end
    end

    context "properties" do 
      let(:json) { JSON.parse(file_fixture('da40xl_airplanes.json')).first }
      let(:listing) { AirplaneListing.new(json) }

      it "should be accessible as instance variables after initialization" do
        listing.model.should == "DA40XL"
        listing.listing_id.should == "1581835"
        listing.registration_number.should == "N866DS"
        listing.total_time.should == "870"
        listing.total_seats.should be_nil
        listing.prop_4_time.should be_nil
      end

      it "should be accessible from the [] method by string or symbol" do
        listing['model'].should == "DA40XL"
        listing['total_time'].should == "870"
        listing[:model].should == listing['model']
        listing[:total_time].should == listing['total_time']
      end
    end

    context "location" do
      it "should default to nil location" do
        a = AirplaneListing.new({})
        a.location.should be_nil
      end

      it "should not be overridden if the listing has a 'location' attribute" do
        a = AirplaneListing.new({'location' => 'Somewhere, USA'})
        a.location.should be_nil
      end

      it "should have a value if the listing has a state" do
        a = AirplaneListing.new({'state' => 'MA'})
        a.location.should_not be_nil
      end

      it "should have a value if the listing has a city and state, different from the state value" do
        state_only = AirplaneListing.new({'state' => 'MA'})
        city_and_state = AirplaneListing.new({'state' => 'MA', 'city' => 'Boston'})
        city_and_state.location.should_not be_nil
        city_and_state.location.should_not == state_only.location
      end

      it "should use the zipcode location, regardless of state and city" do
        zip_only = AirplaneListing.new({'zipcode' => '90210'})
        zip_state = AirplaneListing.new({'zipcode' => '90210', 'state' => 'MA'})
        zip_city_state = AirplaneListing.new({'zipcode' => '90210', 'state' => 'MA', 'city' => 'Boston'})
        zip_only.location.should_not be_nil
        [zip_state, zip_city_state].each { |l| l.location.should == zip_only.location }
      end

      it "should use phone area code if no zipcode and no city+state is available" do
        phone_only = AirplaneListing.new({'home_phone' => '9785551212'})
        zip_only = AirplaneListing.new({'zipcode' => '90210'})
        state_only = AirplaneListing.new({'state' => 'MA'})
        phone_zip = AirplaneListing.new({'zipcode' => '90210', 'home_phone' => '9785551212'})
        phone_state = AirplaneListing.new({'state' => 'MA', 'home_phone' => '9785551212'})
        phone_only.location.should_not be_nil
        phone_zip.location.should == zip_only.location  # zipcode is more reliable than phone area code
        phone_state.location.should == state_only.location # area code roughly gets you into a state
      end

      def check_location_with_phones(phones, expected)
        listing = AirplaneListing.new(phones)
        listing.location.should_not be_nil
        listing.location.should == expected.location  
      end

      it "should use the best available phone number" do
        best_phone_order = ['home_phone', 'work_phone', 'aff_home_phone', 'aff_work_phone']
        phones = {'home_phone' => '111',
                  'work_phone' => '222',
                  'aff_home_phone' => '333',
                  'aff_work_phone' => '444'}
        listings_by_phone = {}
        phones.each {|k, v| listings_by_phone[k] = AirplaneListing.new({k => v})}

        check_location_with_phones(phones, listings_by_phone['home_phone'])
        phones.delete('home_phone')
        check_location_with_phones(phones, listings_by_phone['work_phone'])
        phones.delete('work_phone')
        check_location_with_phones(phones, listings_by_phone['aff_home_phone'])
        phones.delete('aff_home_phone')
        check_location_with_phones(phones, listings_by_phone['aff_work_phone'])
      end

      def check_location_with_zips(zips, expected)
        listing = AirplaneListing.new(zips)
        listing.location.should_not be_nil
        listing.location.should == expected.location  
      end

      it "should use the best available phone number" do
        best_zip_order = ['zipcode', 'aff_zip']
        zips = {'zipcode' => '90210', 'aff_zip' => '02118'}
        listings_by_zip = {}
        zips.each {|k, v| listings_by_zip[k] = AirplaneListing.new({k => v})}

        check_location_with_zips(zips, listings_by_zip['zipcode'])
        zips.delete('zipcode')
        check_location_with_zips(zips, listings_by_zip['aff_zip'])
      end

      it "should return a LatLng for state location" do
        listing = AirplaneListing.new({"state" => 'MA'})
        listing.location.class.should == Geokit::LatLng
      end

      it "should return a LatLng for city, state location" do
        listing = AirplaneListing.new({"city" => "Boston", "state" => 'MA'})
        listing.location.class.should == Geokit::LatLng
      end

      it "should return a LatLng for zipcode location" do
        listing = AirplaneListing.new({"zipcode" => '90210'})
        listing.location.class.should == Geokit::LatLng
      end

      it "should return a LatLng for phone number" do
        listing = AirplaneListing.new({"home_phone" => '9785551212'})
        listing.location.class.should == Geokit::LatLng
      end

      it "should return invalid location for long state name or invalid state" do
        AirplaneListing.new({"state" => 'Massachusetts'}).location.should_not be_valid
        AirplaneListing.new({"state" => 'XX'}).location.should_not be_valid
      end

      it "should return properties" do
        initial_properties = {"state" => 'MA', "city" => "Boston"}
        l = AirplaneListing.new(initial_properties)
        l.properties.should == initial_properties
      end

      it "should support to_s" do
        l = AirplaneListing.new({"state" => 'MA', "city" => "Boston"})
        str = l.to_s
        str.should == l.properties.inspect
      end

      it "should provide location for a real listing" do
        l = AirplaneListing.new(JSON.parse(file_fixture('da40xl_airplanes.json')).first)
        l.location.should be_valid
      end

      it "should calculate location in a specific order" do
        # zipcode, city+state, state, phone
        # zipcode and city+state are about equivalent, and achieve the same accuracy
        # state and phone area code achieve the same accuracy
        # home info is better than seller/company info
        properties = {"zipcode" => "02118", # Boston, MA
                      "city" => "Lowell",   # Lowell, MA (with state)
                      "state" => "MA",      # just MA
                      "home_phone" => "6035551212",   # NH
                      "work_phone" => "2075551212",   # ME
                      "fax" => "8025551212",          # VT
                      "aff_zip" => "90210",           # CA
                      "aff_city" => "Las Vegas",      # Las Vegas, NV
                      "aff_state" => "NV",            # just NV
                      "aff_home_phone" => "8015551212",  # UT
                      "aff_work_phone" => "2065551212",  # WA
                      "aff_fax" => "5035551212"          # OR
                     }
        property_order = ['zipcode', 'city', 'state', 'home_phone', 'work_phone', 'fax',
                          'aff_zip', 'aff_city', 'aff_state', 'aff_home_phone', 'aff_work_phone', 'aff_fax']

        Geokit::Geocoders::AirplaneGeocoder.stub(:geocode)
        property_order.each do |p|
          if p =~ /city/
            Geokit::Geocoders::AirplaneGeocoder.should_receive(:geocode).with("#{properties[p]}, #{properties[p.gsub('city', 'state')]}")
          else
            Geokit::Geocoders::AirplaneGeocoder.should_receive(:geocode).with(properties[p])
          end

          listing = AirplaneListing.new(properties)
          loc = listing.location
          properties.delete(p)
        end
        #pending "home zip, city+state, state, phone should be first, then affiliate versions of those things. IDEA: Make an array of [property, geocoder], ordered with most accurate property first"
      end
    end
  end
end