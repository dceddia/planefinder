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

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
