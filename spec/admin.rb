require 'pry'

require '~/Desktop/ruby/board_db/spec/shared_examples/database_methods'
require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/admin'

describe Admin do

  let(:admin){ Admin.create name: 'Davidson', date_of_birth: '1985.01.22', phone_number: 976431 }

  describe "#delete_ad" do
    it "should delete admin's ad" do
      ad = admin.create_ad title: 'English', text: 'Do you work with beginners?', creating_day: '2014.02.15'
      ad.class.find_by_id(ad.id).id.should == ad.id
      admin.delete_ad ad
      ad.class.find_by_id(ad.id).should == nil
    end

    it "should delete user's ad" do
      user = User.create name: 'Miller', date_of_birth: '1995.12.01', phone_number: 124578 
      ad = user.create_ad title: 'English', text: 'Do you work with beginners?', creating_day: '2014.02.15'
      ad.class.find_by_id(ad.id).id.should == ad.id
      admin.delete_ad ad
      ad.class.find_by_id(ad.id).should == nil
    end
  end
  
end