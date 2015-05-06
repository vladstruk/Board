require 'pry'

require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/user'

describe User do
  let(:client) { Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board") }
  let(:user) { User.new({name: 'Smith', date_of_birth: '1995.12.01', phone_number: 124578}) }
  let(:user2) { User.new({name: 'Johnson', date_of_birth: '1989.11.05', phone_number: 986532}) }

  describe "#save" do
    it "should save users" do
      user.save
      result = client.query("SELECT * FROM users WHERE id = #{user.id}").to_a

      result[0]['id'].should == user.id
      result[0]['name'].should == user.name
      result[0]['date_of_birth'].should == DateTime.strptime(user.date_of_birth, "%Y.%m.%d")
      result[0]['phone_number'].should == user.phone_number

    end

    it "should return only one user" do
      count = client.query("SELECT * FROM users").count
      user.save
      client.query("SELECT * FROM users").count.should == count + 1
    end
  end

  describe "#saved?" do
    it "should return true if object is saved" do
      user.save
      user.saved?.should == true
    end

    it "should return false if object is not saved" do
      user.saved?.should == false
    end
  end

  describe "#update" do
    it "should update table" do
      user.save
      result1 = client.query("SELECT * FROM users WHERE id = #{user.id}").to_a
      user.update date_of_birth: '2003.05.14', phone_number: 123
      result2 = client.query("SELECT * FROM users WHERE id = #{user.id}").to_a
      result1.should_not == result2
      result1[0][:name].should == result2[0][:name]
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

  describe ".find_by_id" do
    it "should return user" do
      user.save
      User.find_by_id(user.id).id.should == user.id
    end
  end

  describe "#create_ad" do
    it "should create id" do
      user.save
      ad = user.create_ad(title: 'English', text: 'Do you work with beginners?')
      added_ad = client.query("SELECT * FROM advertisements ORDER BY id DESC LIMIT 1").to_a
      added_ad[0].equal_values?(ad).should == true
    end
  end

  describe ".count" do
    it "should return number of users" do
      count = client.query("SELECT COUNT(*) FROM users").to_a
      User.count.should == count[0]["COUNT(*)"]
    end
  end
end
