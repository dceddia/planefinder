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
        phone_only = AirplaneListing.new({'home_phone' => '1235551212'})
        zip_only = AirplaneListing.new({'zipcode' => '90210'})
        state_only = AirplaneListing.new({'state' => 'MA'})
        phone_zip = AirplaneListing.new({'zipcode' => '90210', 'home_phone' => '1235551212'})
        phone_state = AirplaneListing.new({'state' => 'MA', 'home_phone' => '1235551212'})
        phone_only.location.should_not be_nil
        phone_zip.location.should == zip_only.location  # zipcode is more reliable than phone area code
        phone_state.location.should_not == state_only.location
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
    end
  end
end