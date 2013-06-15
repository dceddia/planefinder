require "geokit"
require "csv"

module Geokit
  module Geocoders
    __define_accessors

    # Replace name 'External' (below) with the name of your custom geocoder class
    # and use :external to specify this geocoder in your list of geocoders.
    class CityStateGeocoder < Geocoder
      private
      def self.do_geocode(city_state, options = {})
        city, state = city_state.split(',').map(&:strip)
        zips = {}
        CSV.foreach(File.join(File.dirname(__FILE__), "../../db/zip_code_database.csv")) do |row|
          # 0: zipcode, 2: primary_city, 5: state, 9: latitude, 10: longitude
          zips[row[0]] = [row[2], row[5], row[9], row[10]]
        end
        zips.each do |k, info|
          return LatLng.new(info[2], info[3]) if info[0].downcase == city.downcase && info[1] == state
        end
        LatLng.new
      end
    end
  end
end
