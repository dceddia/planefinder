module Planefinder
  # Contains aircraft models like "DA20" (Diamond) or "172" (Cessna)
  class AirplaneModel
    attr_reader :count, :id, :model_group, :name, :category_id, :make_id
    
    def initialize(json, cat_id, make_id)
      @count = json['count'].to_i
      @id = json['id'].to_i
      @model_group = json['model_group'].to_s
      @name = json['name'].to_s
      @category_id = cat_id.to_i
      @make_id = make_id.to_i
    end
    
    def ==(other)
      @count == other.count &&
      @id == other.id &&
      @model_group == other.model_group &&
      @name == other.name &&
      @category_id == other.category_id &&
      @make_id == other.make_id
    end
  end
end