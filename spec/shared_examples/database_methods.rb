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

end