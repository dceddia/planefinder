module Planefinder
  # Contains aircraft models like "DA20" (Diamond) or "172" (Cessna)
  class AirplaneModel
    attr_reader :count, :id, :model_group, :name, :category, :make
    
    def initialize(json, category, make)
      @count = json['count'].to_i
      @id = json['id'].to_i
      @model_group = json['model_group'].to_s
      @name = json['name'].to_s
      @category = category
      @make = make
    end
    
    def ==(other)
      @count == other.count &&
      @id == other.id &&
      @model_group == other.model_group &&
      @name == other.name &&
      @category == other.category &&
      @make == other.make
    end

    def get_listings
      Planefinder.search_by_model_make_category(self, @make, @category)
    end
  end
end