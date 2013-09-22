module Planefinder
  # Contains an airplane listing, including contact info, total engine time, etc.
  class AirplaneListing
    include JSONable
    attr_reader :properties

    PREFERRED_PROPERTY_ORDER = ['zipcode', 'city', 'state', 'home_phone', 'work_phone', 'fax',
                                'aff_zip', 'aff_city', 'aff_state', 'aff_home_phone', 'aff_work_phone', 'aff_fax']

    def initialize(listing_hash)
      # replace empty strings with nil
      @properties = listing_hash.inject({}) do |h, (k,v)|
        v == "" ? h[k] = nil : h[k] = v
        h
      end
      define_attributes(@properties)
    end
    
    def metaclass
      class << self
        self
      end
    end
    
    def define_attributes(hash)
      hash.each do |k, v|
        next if instance_variable_defined?("@#{k}") || self.class.method_defined?(k.to_sym)
        metaclass.send :attr_reader, k
        instance_variable_set("@#{k}".to_sym, v)
      end
    end

    def location
      Geokit::Geocoders::AirplaneGeocoder.geocode(location_text) if location_type
    end

    def location_type
      PREFERRED_PROPERTY_ORDER.each do |p|
        if p =~ /city/
          city = p
          state = p.gsub('city', 'state')
          return "#{city}, #{state}" if @properties[city] and @properties[state]
        else
          return p if @properties[p]
        end
      end
      nil
    end

    def location_text
      # the type might be a "city, state", but otherwise treat it like a single value
      types = location_type.split(", ")
      types.length == 1 ? @properties[types[0]] :  "#{@properties[types[0]]}, #{@properties[types[1]]}"
    end

    def location_description
      location_type + ": " + location_text
    end

    def [](property_name)
      property_name = property_name.to_s if property_name.class == Symbol
      @properties[property_name]
    end

    def to_s
      @properties.inspect
    end
  end
end