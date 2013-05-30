require 'spec_helper'
require 'planefinder'

module Planefinder
  describe AirplaneCategory do
    it "should be initializable with a JSON category description" do
      json_categories = JSON.parse(file_fixture('airplane_categories.json'))
      AirplaneCategory.new(json_categories.first)
    end
  end
end
