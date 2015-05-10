require 'pry'

require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/spec/shared_examples/database_methods'

describe User do
  
  let(:client) { Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board") }
  let(:user) { User.new({name: 'Smith', date_of_birth: '1995.12.01', phone_number: 124578}) }
  let(:user2) { User.new({name: 'Johnson', date_of_birth: '1989.11.05', phone_number: 986532}) }
  let(:saved_obj){ user.save }

  it_behaves_like "database object"

  describe "#save" do
    it "should save users" do
      user.save
      reloaded_user = User.find_by_id(user.id)
      user.equal_database_values?(reloaded_user).should be_truthy
    end

    it "should return only one user" do
      count = User.count
      user.save
      User.count.should == count + 1
    end
  end

  describe "#saved?" do
    it "should return true if object is saved" do
      user.save
      user.saved?.should be_truthy
    end

    it "should return false if object is not saved" do
      user.saved?.should be_falsey
    end
  end

  describe "#update" do
    it "should update table" do
      user.save
      user.update date_of_birth: '2003.05.14', phone_number: 1234
      changed_user = User.find_by_id(user.id)
      user.changed_database_values?(changed_user, ["date_of_birth", "phone_number"]).should be_truthy
    end
  end

  describe "#delete" do
    it "should delete row by attribute" do
      user.save
      client.query("SELECT * FROM users WHERE id = #{user.id}").count.should == 1
      user.delete
      client.query("SELECT * FROM users WHERE id = #{user.id}").count.should be_zero
    end
  end

  describe ".all" do
    it "should return all table data" do
      client.query("DELETE FROM users")
      user.save
      user2.save
      User.all.map(&:id).should == [user.id, user2.id]
    end
  end

  describe "#create_ad" do
    it "should create id" do
      user.save
      ad = user.create_ad title: 'English', text: 'Do you work with beginners?', creating_day: '2014.02.15'
      added_ad = client.query("SELECT * FROM ads ORDER BY id DESC LIMIT 1").to_a
      added_ad[0].equal_values?(ad).should == true
    end
  end

  describe ".count" do
    it "should return number of users" do
      client.query("DELETE FROM users")
      User.count.should be_zero
      user.save
      user2.save
      User.count.should == 2
    end
  end

  describe ".database_attrs" do
    it "should" do
      User.remove_class_variable(:@@database_attrs)
      client = User.client  
      expect(client).to receive(:query).once
      User.database_attrs
      User.database_attrs
    end
  end

end
