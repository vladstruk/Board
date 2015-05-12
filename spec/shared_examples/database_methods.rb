shared_examples_for "database object" do 

  describe ".find_by_id" do
    it "should find object" do
      saved_obj.class.find_by_id(saved_obj.id).id.should == saved_obj.id
    end
  end

  describe "#delete" do
    it "should delete object" do
      obj = saved_obj
      class_name.find_by_id(obj.id).id.should == obj.id
      obj.delete
      class_name.find_by_id(obj.id).should == nil
    end
  end

  describe "#update" do
    it "should update table" do
      saved_obj.update update_params
      changed_obj = saved_obj.class.find_by_id(saved_obj.id)
      saved_obj.changed_database_values?(changed_obj, update_params.keys).should be_truthy
    end
  end

  describe ".count" do
    it "should return number of objects" do
      client.query("DELETE FROM #{class_name.table_name}")
      class_name.count.should be_zero
      saved_obj
      saved_obj2
      saved_obj.class.count.should == 2
    end
  end

  describe ".all" do
    it "should return all table data" do
      client.query("DELETE FROM #{class_name.table_name}")
      saved_obj
      saved_obj2
      saved_obj.class.all.map(&:id).should == [saved_obj.id, saved_obj2.id]
    end
  end

  describe ".sort_by_fields" do
    it "should return objects sorted by fields" do
      client.query("DELETE FROM #{class_name.table_name}")
      saved_obj
      saved_obj2
      saved_obj3
      saved_obj.class.sort_by_fields(sorting_fields).equal_items?([saved_obj3, saved_obj, saved_obj2]).should be_truthy
    end
  end

  describe "#save" do
    it "should save users" do
      saved_obj
      reloaded_obj = saved_obj.class.find_by_id(saved_obj.id)
      saved_obj.equal_database_values?(reloaded_obj).should be_truthy
    end

    it "should return only one user" do
      count = class_name.count
      saved_obj
      saved_obj.class.count.should == count + 1
    end
  end

  describe ".create" do
    it "should create object" do
      created_obj = class_name.create(new_obj_params)
      obj = class_name.find_by_id(created_obj.id)
      created_obj.id.should == obj.id
    end
  end

  describe "#saved?" do
    it "should return true if object has id" do
      obj = class_name.new({id: 1})
      obj.saved?.should be_truthy
    end
    
    it "should return false if object does not have id" do
      class_name.new.saved?.should be_falsey
    end
  end

end