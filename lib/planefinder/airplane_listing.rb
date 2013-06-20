module Planefinder
  # Contains an airplane listing, including contact info, total engine time, etc.
  class AirplaneListing
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
      PREFERRED_PROPERTY_ORDER.each do |p|
        if p =~ /city/
          city = p
          state = p.gsub('city', 'state')
          return Geokit::Geocoders::AirplaneGeocoder.geocode("#{@properties[city]}, #{@properties[state]}") if @properties[city] and @properties[state]
        else
          return Geokit::Geocoders::AirplaneGeocoder.geocode(@properties[p]) if @properties[p]
        end
      end
      nil
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