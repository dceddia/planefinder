require "httparty"
require "json"
require_relative "./planefinder/version"
require_relative "./planefinder/airplane_category"

module Planefinder
  include HTTParty
  base_uri 'www.trade-a-plane.com'

  @@urls = {}
  @@urls[:airplane_categories] = "/app_ajax/get_categories?listing_type_id=1"

  def self.get_categories
    response = self.get(@@urls[:airplane_categories])
    categories = []
    JSON.parse(response.body).each do |cat|
      categories << AirplaneCategory.new(cat)
    end
    categories
  end
end
