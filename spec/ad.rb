require 'pry'

require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/spec/shared_examples/database_methods'

describe Ad do

  let(:client) { Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board") }
  let(:user) { User.new({name: 'Smith', date_of_birth: '1995.12.01', phone_number: 124578}) }

  describe "#update" do
    it "should update table" do
      user.save
      ad = user.create_ad title: 'English', text: 'Do you teach children?', creating_day: '2015.02.01' 
      ad.update title: 'French', text: 'Do you teach beginners?'
      changed_ad = Ad.find_by_id(ad.id)
      ad.changed_database_values?(changed_ad, ["title", "text"]).should be_truthy
    end
  end

  describe ".sort_by_fields" do
    it "should return ads sorted by fields" do
      client.query("DELETE FROM ads")
      user.save
      ad = user.create_ad title: 'English', text: 'Do you teach children?', creating_day: '2015.03.01'
      ad2 = user.create_ad title: 'French', text: 'Do you teach beginners?', creating_day: '2015.04.27'
      ad3 = user.create_ad title: 'English', text: 'Do you teach beginners?', creating_day: '2015.05.04'
      Ad.sort_by_fields([:title, :text]).equal_items?([ad3, ad, ad2]).should be_truthy
    end
  end

  describe ".created_last_week" do
    it "should return ads written during last week" do
      client.query("DELETE FROM ads")
      user.save
      ad = user.create_ad title: 'English', text: 'Do you teach children?', creating_day: '2015.03.01'
      ad2 = user.create_ad title: 'French', text: 'Do you teach beginners?', creating_day: '2015.04.27'
      ad3 = user.create_ad title: 'English', text: 'Do you teach beginners?', creating_day: '2015.05.04'
      Ad.created_last_week.equal_items?([ad3]).should be_truthy
    end
  end

  describe "Ad" do
    let(:saved_user){ user.save }
    let(:obj) { saved_user.create_ad title: 'English', text: 'Do you teach children?', creating_day: '2015.03.01' }
    it_behaves_like "database object"
  end
end