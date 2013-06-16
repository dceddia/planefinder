require "geokit"
require "sequel"

module Geokit
  module Geocoders
    __define_accessors

    # Replace name 'External' (below) with the name of your custom geocoder class
    # and use :external to specify this geocoder in your list of geocoders.
    class AirplaneGeocoder < Geocoder
      private
      def self.do_geocode(address, options = {})
        record = case address
          when /,/
            city, state = address.split(',').map(&:strip)
            self.lookup_by_city_state(city, state)
          when /^\d{5}$/
            self.lookup_by_zip(address)
          when /[A-Z]{2}/
            self.lookup_by_state(address)
          else
            self.lookup_by_phone(address) if self.us_phone_number?(address)
        end
        record ? LatLng.new(record[:latitude], record[:longitude]) : LatLng.new
      end

      def self.db
        File.join(File.dirname(__FILE__), "../../db/geocoding.db")
      end

      def self.lookup_by_city_state(city, state)
        Sequel.sqlite(self.db) do |db|
          db[:zip_codes].first(:city => city, :state => state)
        end
      end

      def self.lookup_by_state(state)
        Sequel.sqlite(self.db) do |db|
          db[:states].first(:abbreviation => state)
        end
      end

      def self.lookup_by_zip(zip)
        Sequel.sqlite(self.db) do |db|
          db[:zip_codes].first(:zip => zip)
        end
      end

      def self.lookup_by_phone(phone)
        area_code = self.sanitize_phone(phone)[0, 3]
        record = Sequel.sqlite(self.db) do |db|
          db[:zip_codes].where(Sequel.like(:area_codes, area_code)).first
        end
        record ? self.lookup_by_state(record[:state]) : nil
      end

      def self.sanitize_phone(str)
        str.gsub(/[+( ).-]/, '')[/\d{10}$/]
      end

      def self.us_phone_number?(str)
        self.sanitize_phone(str) =~ /^\d{10}$/
      end
    end
  end
end
