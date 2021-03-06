require 'spec_helper'

describe Planefinder do
  it "should have a version" do
    Planefinder::VERSION.should_not be_empty
  end

  context "retrieving categories" do
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
        it "should retrieve a list of Single Engine makes for category 1" do
          cat = mock(Planefinder::AirplaneCategory, :id => 1)
          makes = Planefinder.send(method_name, cat)
          makes.length.should == 136
          makes.select { |m| m.name == 'Cessna' }.length.should == 1
        end

        it "should retrieve a list of Jet makes for category 4" do
          cat = double(Planefinder::AirplaneCategory, :id => 4)
          makes = Planefinder.send(method_name, cat)
          makes.length.should == 28
          makes.select { |m| m.name == 'Boeing' }.length.should == 1
        end

        it "should retrieve a list of Helicopter makes for category 100" do
          cat = double(Planefinder::AirplaneCategory, :id => 100)
          makes = Planefinder.send(method_name, cat)
          makes.length.should == 9
          makes.select { |m| m.name == 'Robinson' }.length.should == 1
        end

        it "should create AirplaneMakes with real category objects" do
          cat = double(Planefinder::AirplaneCategory, :id => 100)
          makes = Planefinder.send(method_name, cat)
          makes.first.category.should == cat          
        end
      end
    end
  end
  
  context "retrieving models" do
    %w[get_models_for_category_and_make get_models].each do |method_name|
      describe "##{method_name}" do    
        it "should retrieve an array of AirplaneModel" do
          cat = double(Planefinder::AirplaneCategory, :id => 1)
          make = double(Planefinder::AirplaneMake, :id => 155)
          Planefinder.send(method_name, cat, make).each do |model|
            model.class.should == Planefinder::AirplaneModel
          end
        end
      
        it "should retrieve a list of Diamond aircraft models for category 1, make 155" do
          cat = double(Planefinder::AirplaneCategory, :id => 1)
          make = double(Planefinder::AirplaneMake, :id => 155)
          models = Planefinder.send(method_name, cat, make)
          models.select { |m| m.name == 'DA40' }.length.should == 1
        end
      
        it "should retrieve a list of Robinson helicopter models for category 100, make 406" do
          cat = double(Planefinder::AirplaneCategory, :id => 100)
          make = double(Planefinder::AirplaneMake, :id => 406)
          models = Planefinder.send(method_name, cat, make)
          models.select { |m| m.name == 'R44' }.length.should == 1
        end

        it "should create AirplaneModels with real category and make objects" do
          cat = double(Planefinder::AirplaneCategory, :id => 100)
          make = double(Planefinder::AirplaneMake, :id => 406)
          models = Planefinder.send(method_name, cat, make)
          models.first.category.should == cat
          models.first.make.should == make
        end
      end
    end
  end
  
  context "retrieving airplane listings" do
    describe "#search_by_model_make_category" do
      it "should retrieve an array of AirplaneListing" do
        model = double(Planefinder::AirplaneModel, :name => "DA40XL")
        make = double(Planefinder::AirplaneMake, :name => "Diamond")
        cat = double(Planefinder::AirplaneCategory, :name => "Single Engine Piston")
        listings = Planefinder.search_by_model_make_category(model, make, cat)
        listings.each { |l| l.class.should == Planefinder::AirplaneListing }
        listings.length.should == 6
      end
    end
  end

  context "searching by freeform string" do
    pending "should be supported"
  end
end
