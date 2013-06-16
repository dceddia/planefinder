require "geokit"
require "csv"

module Geokit
  module Geocoders
    __define_accessors

    # Replace name 'External' (below) with the name of your custom geocoder class
    # and use :external to specify this geocoder in your list of geocoders.
    class StateGeocoder < Geocoder
      private
      def self.do_geocode(state, options = {})
        db = Sequel.sqlite(File.join(File.dirname(__FILE__), "../../db/geocoding.db"))
        record = db[:states].first(:abbreviation => state)
        record ? LatLng.new(record[:latitude], record[:longitude]) : LatLng.new
      end
    end
  end
end
