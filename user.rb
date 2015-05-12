require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/lib/database_methods'
require '~/Desktop/ruby/board_db/lib/params_handler'


class User
  include DatabaseMethods
  include ParamsHandler

  def initialize data = {}
    data.symbolize_keys!
    @id = data[:id]
    @name = data[:name]
    @date_of_birth = date_parser data[:date_of_birth]
    @phone_number = data[:phone_number]
    @role = self.class
  end

  def role
    @role
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

  def id
    @id
  end

  def delete_ad ad
      if ad.user_id == id
        ad.delete
      else
        false
      end
  end

  def create_ad params
    Ad.create(params.merge(user_id: id))
  end

   
    #Class methods
  def self.table_name
    "users"
  end

end