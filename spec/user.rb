require 'pry'

require '~/Desktop/ruby/board_db/user'
require '~/Desktop/ruby/board_db/spec/shared_examples/database_methods'

describe User do
  
  let(:client){ Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board") }
  let(:user){ User.new(name: 'Miller', date_of_birth: '1995.12.01', phone_number: 124578) }
  let(:user2){ User.new(name: 'Smith', date_of_birth: '1989.11.05', phone_number: 986532) }
  let(:user3){ User.new(name: 'Johnson', date_of_birth: '1989.11.05', phone_number: 986532) }
  #TODO check that 'lets' are used more than one time
  let(:saved_obj){ user.save }
  let(:saved_obj2){ user2.save }
  let(:saved_obj3){ user3.save }
  let(:class_name){ User }

  it_behaves_like "database object" do
    let(:update_params){ {date_of_birth: '2003.05.14', phone_number: 1234} }
    let(:sorting_fields){ [:name, :date_of_birth] }
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

  describe "#create_ad" do
    it "should create id" do
      user.save
      ad = user.create_ad title: 'English', text: 'Do you work with beginners?', creating_day: '2014.02.15'
      added_ad = client.query("SELECT * FROM ads ORDER BY id DESC LIMIT 1").to_a
      added_ad[0].equal_values?(ad).should == true
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
