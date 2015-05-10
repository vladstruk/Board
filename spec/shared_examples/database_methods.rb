shared_examples_for "database object" do
  describe ".find_by_id" do
    it "should find object" do
      obj.class.find_by_id(obj.id).id.should == obj.id
    end
  end
end