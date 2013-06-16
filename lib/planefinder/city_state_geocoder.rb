require "geokit"
require "sequel"

module Geokit
  module Geocoders
    __define_accessors

    # Replace name 'External' (below) with the name of your custom geocoder class
    # and use :external to specify this geocoder in your list of geocoders.
    class CityStateGeocoder < Geocoder
      private
      def self.do_geocode(city_state, options = {})
        city, state = city_state.split(',').map(&:strip)
        db = Sequel.sqlite(File.join(File.dirname(__FILE__), "../../db/geocoding.db"))
        record = db[:zip_codes].first(:city => city, :state => state)
        record ? LatLng.new(record[:latitude], record[:longitude]) : LatLng.new
      end
    end
  end
end
