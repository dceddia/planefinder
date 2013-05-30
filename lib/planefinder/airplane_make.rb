module Planefinder
  class AirplaneMake
    attr_reader :count, :id, :name
    
    def initialize(json)
      @count = json['count'].to_i
      @id = json['id'].to_i
      @name = json['name'].to_s
    end

    def ==(other)
      @count == other.count &&
      @id == other.id &&
      @name == other.name
    end
  end
end
