require "httparty"
require "json"
require "uri"
require "geokit"
require_relative "./planefinder/version"
require_relative "./planefinder/airplane_category"
require_relative "./planefinder/airplane_make"
require_relative "./planefinder/airplane_model"
require_relative "./planefinder/airplane_listing"
require_relative "./planefinder/state_geocoder"
require_relative "./planefinder/city_state_geocoder"
require_relative "./planefinder/airplane_geocoder"

module Planefinder
  include HTTParty
  base_uri 'www.trade-a-plane.com'

  @@urls = {}
  @@urls[:airplane_categories] = "/app_ajax/get_categories?listing_type_id=1"
  @@urls[:airplane_makes_for_category] = "/app_ajax/get_aircraft_makes?category_id=%s&make_type_id=1"
  @@urls[:airplane_models_for_category_and_make] = "/app_ajax/get_aircraft_models?category_id=%s&make_id=%s"
  @@urls[:search_by_model_make_category] = "/app_ajax/search?s-type=aircraft&model=%s&make=%s&category=%s"

  def self.valid_args?(*args)
    args.all? { |a| a.to_i > 0 }
  end
  
  def self.get_categories
    response = self.get(@@urls[:airplane_categories])
    categories = []
    JSON.parse(response.body).each do |cat|
      next if(cat.has_key?('special_use_counts'))
      categories << AirplaneCategory.new(cat)
    end
    categories
  end

  def self.get_makes_for_category(category)
    response = self.get(@@urls[:airplane_makes_for_category] % category.id)
    makes = []
    JSON.parse(response.body).each do |make|
      makes << AirplaneMake.new(make, category.id)
    end
    makes
  end
  
  def self.get_models_for_category_and_make(category, make)
    response = self.get(@@urls[:airplane_models_for_category_and_make] % [category.id, make.id])
    models = []
    JSON.parse(response.body).each do |model|
      models << AirplaneModel.new(model, category.id, make.id)
    end
    models
  end
  
  def self.search_by_model_make_category(model, make, cat)
    response = self.get(@@urls[:search_by_model_make_category] % [model, make, cat].map { |s| URI.escape(s.name) })
    listings = []
    JSON.parse(response.body).each do |listing|
      listings << AirplaneListing.new(listing)
    end
    listings
  end
  
  class << Planefinder
    alias_method :get_makes, :get_makes_for_category
    alias_method :get_models, :get_models_for_category_and_make
  end
end
