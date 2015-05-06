require 'pry'

require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/ad'

describe Ad do
  describe "#update" do
    it "should update table" do
      client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board")
      user = User.new(name: 'Smith', date_of_birth: '1995.12.01', phone_number: 124578)
      user.save

      ad = user.create_ad title: 'English', text: 'Do you teach children?'
      result1 = client.query("SELECT * FROM advertisements WHERE id = #{ad.id}").to_a
      ad.update title: 'French', text: 'Do you teach beginners?'
      result2 = client.query("SELECT * FROM advertisements WHERE id = #{ad.id}").to_a

      result1[0]["id"].should == result2[0]["id"]
      result2[0]["title"].should == 'French'
      result2[0]["text"].should == 'Do you teach beginners?'
      result1[0]["user_id"].should == result2[0]["user_id"]
    end
  end
end