shared_examples_for "database object" do 

  describe ".find_by_id" do
    it "should find object" do
      saved_obj.class.find_by_id(saved_obj.id).id.should == saved_obj.id
    end
  end

  describe "#delete" do
    it "should delete object" do
      # TODO: replace query with find by id
      table_name = saved_obj.class.table_name
      client.query("SELECT * FROM #{table_name} WHERE id = #{saved_obj.id}").count.should == 1
      saved_obj.delete
      client.query("SELECT * FROM #{table_name} WHERE id = #{saved_obj.id}").count.should be_zero
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
      class_name.count.should == 2
    end
  end

end