require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'
require '~/Desktop/ruby/board_db/ad'

class User
  @@client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board")
  def initialize data
    data.symbolize_keys!
    @id = data[:id]
    @name = data[:name]
    @date_of_birth = data[:date_of_birth]
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
    @@client.query("INSERT INTO users (name, date_of_birth, phone_number)
                      VALUES ('#{name}', '#{date_of_birth}', #{phone_number})")
    @id = @@client.last_id
  end

  def id
    @id
  end

  def saved?
    ! @id.nil?
  end

  def update params
    #changed_attrs = params.map { |k, v| "#{k} = '#{v}'" }.join(', ')
    changed_attrs = []
    params.each { |k, v| changed_attrs.push "#{k} = '#{v}'" }
    @@client.query("UPDATE users SET #{changed_attrs.join(', ')} WHERE id = #{id}")
  end

  def delete
    @@client.query("DELETE FROM users WHERE id = #{id}")
  end

  def self.all
    users = @@client.query("SELECT * FROM users").to_a
    all_users = users.map {|data| User.new(data)}
  end

  def self.find_by_id id
    data = @@client.query("SELECT * FROM users WHERE id = #{id}").to_a
    User.new(data[0])
  end

  def create_ad params
    @@client.query("INSERT INTO advertisements (title, text, user_id)
                    VALUES ('#{params[:title]}', '#{params[:text]}', '#{id}')")
    Ad.new({id: @@client.last_id, title: params[:title], text: params[:text], user_id: id})
  end

  def self.count
    #@@client.query("SELECT * FROM users").count
    @@client.query("SELECT COUNT(*) count FROM users").to_a[0]['count']
  end

end
