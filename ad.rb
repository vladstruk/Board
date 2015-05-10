require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/array'
require '~/Desktop/ruby/board_db/lib/database_methods'
require '~/Desktop/ruby/board_db/lib/params_handler'

class Ad
  include DatabaseMethods
  include ParamsHandler

  def initialize data
    data.symbolize_keys!
    @id = data[:id]
    @title = data[:title]
    @text = data[:text]
    @creating_day = date_parser data[:creating_day]
    @user_id = data[:user_id]
  end

  def id
    @id
  end

  def title
    @title
  end

  def text
    @text
  end

  def creating_day
    @creating_day
  end

  def user_id
    @user_id
  end


  def update params
    changing_attrs = params.map { |k, v| "#{k} = '#{v}'" }.join(', ')
    client.query("UPDATE ads SET #{changing_attrs} WHERE id = #{id} ")
  end


    #Class methods
  def self.sort_by_fields fields
    ads = client.query("SELECT * FROM ads ORDER BY #{fields.join(', ')}").to_a
    ads.map { |ad| Ad.new(ad) }
  end

  def self.created_last_week
    ads = client.query("SELECT * FROM ads WHERE DATEDIFF(CURRENT_DATE, creating_day) <= 7").to_a
    ads.map {|ad| Ad.new(ad)}
  end

  def self.table_name
    "ads"
  end

end



