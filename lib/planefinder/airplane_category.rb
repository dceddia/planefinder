module Planefinder
  class AirplaneCategory
    attr_reader :count, :id, :name, :sort_priority

    def initialize(json_category, special = false)
      validate_category(json_category)
      @count = json_category['count'].to_i
      @id = json_category['id'].to_i
      @name = json_category['name'].to_s
      @sort_priority = json_category['sort_priority'].to_i
    end

    def validate_category(cat)
      throw "Category must have count, id, name, and sort_priority fields" unless
        ['count', 'id', 'name', 'sort_priority'].all? { |field| cat.include?(field) }
    end
  end
end
