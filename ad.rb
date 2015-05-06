require 'pry'
require 'mysql2'
require '~/Desktop/ruby/board_db/hash'

class Ad
  @@client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board")
  def initialize data
    @id = data[:id]
    @title = data[:title]
    @text = data[:text]
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

  def user_id
    @user_id
  end
end
