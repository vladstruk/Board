require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/lib/database_methods'
require '~/Desktop/ruby/board_db/lib/params_handler'


class User
  include DatabaseMethods
  include ParamsHandler

  def initialize data
    data.symbolize_keys!
    @id = data[:id]
    @name = data[:name]
    @date_of_birth = date_parser data[:date_of_birth]
    @phone_number = data[:phone_number]
  end

  def name
    @name
  end

  def date_of_birth
    @date_of_birth
  end

  def phone_number
    @phone_number
  end


  def save
    client.query("INSERT INTO users (name, date_of_birth, phone_number)
                      VALUES ('#{name}', '#{date_of_birth}', #{phone_number})")
    @id = client.last_id
    self
  end

  def id
    @id
  end

  def saved?
    !@id.nil?
  end

  def create_ad params
    client.query("INSERT INTO ads (title, text, creating_day, user_id)
                    VALUES ('#{params[:title]}', '#{params[:text]}', '#{params[:creating_day]}', '#{id}')")
    Ad.new({id: User.client.last_id, title: params[:title], text: params[:text], creating_day: params[:creating_day], user_id: id})
  end

   
    #Class methods
  def self.table_name
    "users"
  end

end