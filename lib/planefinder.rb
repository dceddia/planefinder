require "planefinder/version"
require "httparty"
require "json"

module Planefinder
  include HTTParty
  base_uri 'www.trade-a-plane.com'

  @@urls = {}
  @@urls[:airplane_categories] = "/app_ajax/get_categories?listing_type_id=1"

  def self.get_categories
    response = self.get(@@urls[:airplane_categories])
    JSON.parse(response.body)
  end
end
