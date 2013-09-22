module Planefinder
  # Contains aircraft makes like "Cessna" or "Robinson"
  class AirplaneMake
    include JSONable
    attr_reader :count, :id, :name, :category
    
    def initialize(json, category)
      @count = json['count'].to_i
      @id = json['id'].to_i
      @name = json['name'].to_s
      @category = category
    end

    def ==(other)
      @count == other.count &&
      @id == other.id &&
      @name == other.name &&
      @category == other.category
    end
    
    def get_models
      Planefinder.get_models_for_category_and_make(@category, self)
    end
  end
end
