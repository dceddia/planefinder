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
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/state_latlon.csv")) do |row|
          return LatLng.new(row[1], row[2]) if row[0] == state
        end
        nil
      end
    end
  end
end
