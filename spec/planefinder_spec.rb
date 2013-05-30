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

  context "retrieving makes" do
    before do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, 
                           'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=1&make_type_id=1',
                           :body => file_fixture('single_engine_makes.json'))
    end

    it "should retrieve a list of Single Engine makes for type_id 1" do
      makes = Planefinder.get_makes_for_category(1)
      makes.length.should == 136
    end

    it "should accept strings or integers" do
      makes_int = Planefinder.get_makes_for_category(1)
      makes_str = Planefinder.get_makes_for_category("1")
      makes_int.length.should == makes_str.length
      makes_int.should == makes_str
    end
  end
end
