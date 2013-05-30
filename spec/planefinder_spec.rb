require 'planefinder'
require 'fakeweb'

describe Planefinder do
  it "should have a version" do
    Planefinder::VERSION.should_not be_empty
  end

  context "retrieving categories" do
    before do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, 
                           'http://www.trade-a-plane.com/app_ajax/get_categories?listing_type_id=1',
                           :body => file_fixture('airplane_categories.json'))
    end

    it "should retrieve aircraft categories" do
      categories = Planefinder.get_categories
      categories.length.should == 9
      categories.each { |c| c.class.should == Planefinder::AirplaneCategory }
    end

    it "should ignore the 'special_use_counts' category" do
      categories = Planefinder.get_categories
      categories.each { |c| c.id.should be > 0 }
    end
  end
end
