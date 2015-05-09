require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/ad'
require '~/Desktop/ruby/board_db/lib/database_methods'


class User
  include DatabaseMethods

  def initialize data
    data.symbolize_keys!
    @id = data[:id]
    @name = data[:name]
    @date_of_birth = date_parser data[:date_of_birth]
    @phone_number = data[:phone_number]
  end

  def self.table_name
    "users"
  end

  def self.database_attrs
    return @@database_attrs if defined? @@database_attrs   
    fields = client.query("DESC users").to_a
    @@database_attrs = fields.map {|obj| obj["Field"]}
  end

  def date_parser data
    if data.is_a? String
      Date.strptime(data, "%Y.%m.%d")
     else
      data
    end
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
  end

  def id
    @id
  end

  def saved?
    !@id.nil?
  end

  def update params
    #changed_attrs = params.map { |k, v| "#{k} = '#{v}'" }.join(', ')
    changed_attrs = []
    params.each { |k, v| changed_attrs.push "#{k} = '#{v}'" }
    client.query("UPDATE users SET #{changed_attrs.join(', ')} WHERE id = #{id}")
  end

  def delete
    client.query("DELETE FROM users WHERE id = #{id}")
  end

  def self.all
    users = client.query("SELECT * FROM users").to_a
    all_users = users.map {|data| User.new(data)}
  end

  def create_ad params
    client.query("INSERT INTO ads (title, text, creating_day, user_id)
                    VALUES ('#{params[:title]}', '#{params[:text]}', '#{params[:creating_day]}', '#{id}')")
    Ad.new({id: User.client.last_id, title: params[:title], text: params[:text], creating_day: params[:creating_day], user_id: id})
  end

  def self.count
    #@@client.query("SELECT * FROM users").count
    client.query("SELECT COUNT(*) count FROM users").to_a[0]['count']
  end
end