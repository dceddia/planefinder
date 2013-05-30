require 'planefinder'
require 'fakeweb'

describe Planefinder do
  it "should have a version" do
    Planefinder::VERSION.should_not be_empty
  end

  context "retrieving categories" do
    before do
      FakeWeb.allow_net_connect = false
      response_json = File.join(File.dirname(__FILE__), 'fixtures', 'airplane_categories.json')
      FakeWeb.register_uri(:get, 'http://www.trade-a-plane.com/app_ajax/get_categories?listing_type_id=1', :body => response_json)
    end

    it "should retrieve aircraft categories" do
      categories = Planefinder.get_categories
      categories.length.should == 10
      categories.each { |c| c.class.should == AirplaneCategory.class }
    end
  end
end
