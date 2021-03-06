require 'pry'

require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/spec/shared_examples/database_methods'

describe Ad do

  let(:client){ Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board") }
  let(:user){ User.new({name: 'Smith', date_of_birth: '1995.12.01', phone_number: 124578}) }
  let(:saved_user){ user.save }
  let(:saved_obj){ saved_user.create_ad(title: 'English', text: 'Do you teach children?', creating_day: '2015.03.01') }
  let(:saved_obj2){ saved_user.create_ad(title: 'French', text: 'Do you teach beginners?', creating_day: '2015.04.27') }
  let(:class_name){ Ad }

  it_behaves_like "database object" do
    let(:saved_obj3){ saved_user.create_ad(title: 'English', text: 'Do you teach beginners?', creating_day: '2015.05.04') }
    let(:update_params){ {title: 'French', text: 'Do you teach beginners?'} }
    let(:sorting_fields){ [:title, :text] }
    let(:new_obj_params){ {title: 'French', text: 'Do you teach beginners?', creating_day: '2015.04.27'} }
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
    
end