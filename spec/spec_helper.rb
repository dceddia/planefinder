# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'planefinder'
require 'fakeweb'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.add_setting :fixture_path
  config.fixture_path = 'foo'
  
  config.before(:suite) do
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_categories?listing_type_id=1',
                         :body => file_fixture('airplane_categories.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_aircraft_models?category_id=1&make_id=155',
                         :body => file_fixture('diamond_models.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_aircraft_models?category_id=100&make_id=406',
                         :body => file_fixture('robinson_models.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=1&make_type_id=1',
                         :body => file_fixture('single_engine_makes.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=4&make_type_id=1',
                         :body => file_fixture('jet_makes.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=100&make_type_id=1',
                         :body => file_fixture('piston_helicopter_makes.json'))
    FakeWeb.register_uri(:get, 
                         'http://www.trade-a-plane.com/app_ajax/search?s-type=aircraft&model=DA40XL&make=Diamond&category=Single%20Engine%20Piston',
                         :body => file_fixture('diamond_models.json'))
  end

  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end
end
