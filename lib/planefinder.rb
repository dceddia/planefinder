require "httparty"
require "json"
require_relative "./planefinder/version"
require_relative "./planefinder/airplane_category"
require_relative "./planefinder/airplane_make"

module Planefinder
  include HTTParty
  base_uri 'www.trade-a-plane.com'

  @@urls = {}
  @@urls[:airplane_categories] = "/app_ajax/get_categories?listing_type_id=1"
  @@urls[:airplane_makes_for_category] = "/app_ajax/get_aircraft_makes?category_id=1&make_type_id="

  def self.get_categories
    response = self.get(@@urls[:airplane_categories])
    categories = []
    JSON.parse(response.body).each do |cat|
      next if(cat.has_key?('special_use_counts'))
      categories << AirplaneCategory.new(cat)
    end
    categories
  end

  def self.get_makes_for_category(cat_id)
    response = self.get(@@urls[:airplane_makes_for_category] + cat_id.to_s)
    makes = []
    JSON.parse(response.body).each do |make|
      makes << AirplaneMake.new(make)
    end
    makes
  end
end
