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
          when /\d{5}/
            self.lookup_by_zip(address)
          when /[A-Z]{2}/
            self.lookup_by_state(address)
        end
        record ? LatLng.new(record[:latitude], record[:longitude]) : LatLng.new
      end

      def self.db
        File.join(File.dirname(__FILE__), "../../db/geocoding.db")
      end

      def self.lookup_by_city_state(city, state)
        Sequel.sqlite(self.db) do |db|
          record = db[:zip_codes].first(:city => city, :state => state)
        end
      end

      def self.lookup_by_state(state)
        Sequel.sqlite(self.db) do |db|
          record = db[:states].first(:abbreviation => state)
        end
      end

      def self.lookup_by_zip(zip)
        Sequel.sqlite(self.db) do |db|
          record = db[:zip_codes].first(:zip => zip)
        end
      end
    end
  end
end
