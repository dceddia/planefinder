module Planefinder
  # Contains aircraft makes like "Cessna" or "Robinson"
  class AirplaneMake
    attr_reader :count, :id, :name, :category_id
    
    def initialize(json, category_id)
      @count = json['count'].to_i
      @id = json['id'].to_i
      @name = json['name'].to_s
      @category_id = category_id.to_i
    end

    def ==(other)
      @count == other.count &&
      @id == other.id &&
      @name == other.name &&
      @category_id == other.category_id
    end
  end
end
