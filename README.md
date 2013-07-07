# Planefinder

Planefinder lets you query Trade-A-Plane (www.trade-a-plane.com) for aircraft listings. You can search by category, make, and model of aircraft, or use a freeform search query.

Once you have the listing, you can access all of its properties (airframe time, engine TBO, tail number, etc.) and look up its geolocation.

Geolocation is something that TAP's API doesn't offer natively, so it's a best-guess based on zipcode, city/state, and phone number. But having this ability allows you to narrow down your search to within a radius of where you live, or sort by distance from your home base. It's helpful when you're looking for an aircraft but don't want to waste a ton of time travelling to see them.

## Installation

Add this line to your application's Gemfile:

    gem 'planefinder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install planefinder

## Usage

First, let's require planefinder and get a list of airplane categories:

    require 'planefinder'

    categories = Planefinder.get_categories
    categories.map(&:name)    #=> ["Single Engine Piston", "Multi Engine Piston", "TurboProp", ...]

From here, we can take a look at the makes within a category. This will include manufacturers like Cessna, Piper, and Cirrus.

    makes = categories.first.get_makes     # .first is 'Single Engine Piston'

Lets say we want to look for a Cirrus.

	cirrus = makes.select { |m| m.name =~ /Cirrus/ }.first
	cirrus_models = cirrus.get_models
	cirrus_models.map(&:name)  #=> ["SR20", "SR20-G2", "SR20-G2 GTS", "SR20-G3", ... ]

I'd like to look for an SR22 or an SR20.

	sr20_sr22 = cirrus_models.select { |c| c.name =~ /^SR20$/ || c.name =~ /^SR22$/ }

Lets find all the listings for sale for that make/model:

	listings = sr20_sr22.inject([]) { |arr, model| arr += model.get_listings }
	listings.length   #=> 39

What I really want is SR20s and SR22s for sale near me. Flying across the country to look at airplanes will get expensive quick...

	# 02118 is the zipcode for Boston, MA
	here = Geokit::Geocoders::AirplaneGeocoder.geocode("02118")

	# unit defaults to miles (statute, that is)
	nearby_listings = listings.reject { |l| l.location.distance_from(here) > 500 } 
	nearby_listings.length   #=> 7 -- that's better
	nearby_listings.each do |l| 
		puts l.price + " " + l.location_text + " (" + l.location_type + ")"
	end 

	#=>
	# 169000.00 04605 (zipcode)
	# 159900.00 Fredericksburg, VA (city, state)
	# 269000.00 VA (state)
	# 0.00 Portsmouth, NH (city, state)
	# 199000.00 NY (state)
	# 189000.00 Petersburg, VA (city, state)
	# 169000.00 Providence, RI (city, state)

From here I can look at the listings and see which ones I might want to investigate.

## Geocoding

Geocoding support is built on top of Geokit (http://geokit.rubyforge.org/). The `AirplaneGeocoder` class is a custom geocoder that lets you search by zipcode, city+state, state, and phone number. Here are some examples:

	# search by zipcode
	boston = Geokit::Geocoders::AirplaneGeocoder.geocode("02118")   

	# search by 'city, state'
	san_fran = Geokit::Geocoders::AirplaneGeocoder.geocode("San Francisco, CA")

	# search by 2-letter state code   
	colorado = Geokit::Geocoders::AirplaneGeocoder.geocode("CO")    
	
	# search by phone number
	maine = Geokit::Geocoders::AirplaneGeocoder.geocode("203-555-1212")   

Phone number searches just strip off the area code and resolve to a state.

`AirplaneListing` will attempt to give the most accurate location it can, based on what's available. Zipcode or 'city, state' are the best, followed by state and then phone number.

## Future Work

All of this would be easier to access in the form of a webapp. Perhaps I'll get around to writing something with Rails or Sinatra. Or, if you want to do it yourself, feel free :)

## Acknowledgements

Thanks to Trade-A-Plane for a great site and a nice iPhone app. Without the existing (and relatively recent) iPhone/mobile API, this wouldn't have been possible.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
