require 'fakeweb'

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
        it "should not allow nil makes" do
          expect { Planefinder.send(method_name, nil) }.to raise_error("make_id must be a number > 0")
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
        it "should throw an error if category_id or make_id are nil" do
          expect { Planefinder.send(method_name, nil, nil) }.to raise_error("category_id and make_id must be > 0")
          expect { Planefinder.send(method_name, 1, nil) }.to raise_error("category_id and make_id must be > 0")
          expect { Planefinder.send(method_name, nil, 1) }.to raise_error("category_id and make_id must be > 0")
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
  
  context "retrieving airplane listings" do
    describe "#get_listings_for_model_make_category" do
      it "should throw an error if category_id, model_id, or make_id are nil" do
        bad_args = [nil, 1].repeated_permutation(3).to_a.keep_if { |p| p != [1,1,1] }
        bad_args.each do |args|
          expect { Planefinder.get_listings_for_model_make_category(*args) }.to raise_error("category_id, model_id, and make_id must be > 0")
        end
      end
      
      pending "Rename this to search_by_model_make_category, and make it take strings, and call the /app_ajax/search url"
    end
  end
end
