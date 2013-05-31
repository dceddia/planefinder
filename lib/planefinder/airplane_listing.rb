module Planefinder
  # Contains an airplane listing, including contact info, total engine time, etc.
  class AirplaneListing
    def initialize(json)
      @properties = json
      define_attributes(@properties)
    end
    
    def metaclass
      class << self
        self
      end
    end
    
    def define_attributes(hash)
      hash.each do |k, v|
        metaclass.send :attr_reader, k
        instance_variable_set("@#{k}".to_sym, v)
      end
    end
  end
end