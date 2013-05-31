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
    %w[get_makes_for_category get_makes].each do |method_name|
      describe "##{method_name}" do
        before do
          FakeWeb.allow_net_connect = false
          FakeWeb.register_uri(:get, 
                               'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=1&make_type_id=1',
                               :body => file_fixture('single_engine_makes.json'))
          FakeWeb.register_uri(:get, 
                               'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=4&make_type_id=1',
                               :body => file_fixture('jet_makes.json'))
          FakeWeb.register_uri(:get, 
                               'http://www.trade-a-plane.com/app_ajax/get_aircraft_makes?category_id=100&make_type_id=1',
                               :body => file_fixture('piston_helicopter_makes.json'))
        end

        it "should retrieve a list of Single Engine makes for category 1" do
          makes = Planefinder.send(method_name, 1)
          makes.length.should == 136
          makes.select { |m| m.name == 'Cessna' }.length.should == 1
        end

        it "should retrieve a list of Jet makes for category 4" do
          makes = Planefinder.send(method_name, 4)
          makes.length.should == 28
          makes.select { |m| m.name == 'Boeing' }.length.should == 1
        end

        it "should retrieve a list of Helicopter makes for category 100" do
          makes = Planefinder.send(method_name, 100)
          makes.length.should == 9
          makes.select { |m| m.name == 'Robinson' }.length.should == 1
        end
    
        it "should accept strings or integers" do
          makes_int = Planefinder.send(method_name, 1)
          makes_str = Planefinder.send(method_name, "1")
          makes_int.length.should == makes_str.length
          makes_int.should == makes_str
        end
      end
    end
  end
  
  context "retrieving models" do
    %w[get_models_for_category_and_make get_models].each do |method_name|
      describe "##{method_name}" do
        before do
          FakeWeb.allow_net_connect = false
          FakeWeb.register_uri(:get, 
                               'http://www.trade-a-plane.com/app_ajax/get_aircraft_models?category_id=1&make_id=155',
                               :body => file_fixture('diamond_models.json'))
          FakeWeb.register_uri(:get, 
                               'http://www.trade-a-plane.com/app_ajax/get_aircraft_models?category_id=100&make_id=406',
                               :body => file_fixture('robinson_models.json'))
        end
      
        it "should retrieve an array of AirplaneModel" do
          Planefinder.send(method_name, 1, 155).each do |model|
            model.class.should == Planefinder::AirplaneModel
          end
        end
      
        it "should retrieve a list of Diamond aircraft models for category 1, make 155" do
          models = Planefinder.send(method_name, 1, 155)
          models.select { |m| m.name == 'DA40' }.length.should == 1
        end
      
        it "should retrieve a list of Robinson helicopter models for category 100, make 406" do
          models = Planefinder.send(method_name, 100, 406)
          models.select { |m| m.name == 'R44' }.length.should == 1
        end
      end
    end
  end
end
