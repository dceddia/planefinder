module Planefinder
  # Contains an airplane listing, including contact info, total engine time, etc.
  class AirplaneListing
    def initialize(listing_hash)
      @properties = listing_hash
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
      if @properties['zipcode']
        @properties['zipcode']
      elsif @properties['state'] and @properties['city']
        Geokit::Geocoders::CityStateGeocoder.geocode(@properties['city'] + ", " + @properties['state'])
      elsif best_phone
        best_phone
      elsif @properties['state']
        Geokit::Geocoders::StateGeocoder.geocode(@properties['state'])
      end
    end

    def best_phone
      best_phone_order = ['home_phone', 'work_phone', 'aff_home_phone', 'aff_work_phone']
      best_phone_order.each { |phone| return @properties[phone] if @properties[phone]}
      return nil
    end

    def [](property_name)
      property_name = property_name.to_s if property_name.class == Symbol
      @properties[property_name]
    end
  end
end