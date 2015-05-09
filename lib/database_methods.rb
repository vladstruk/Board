require 'pry'
require 'mysql2'

module DatabaseMethods

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend(ClassMethods)
  end

  module ClassMethods
    def find_by_id id
      data = client.query("SELECT * FROM #{self.table_name} WHERE id = #{id}").to_a
      self.new(data[0])
    end

    def client
      @@client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "board")
    end
  end

  
  module InstanceMethods
    def client
      self.class.client
    end

    def equal_database_values? user
      self.class.database_attrs.all? {|v| send(v) == user.send(v)} 
    end
  
    #def changed_database_values? user, changed_fields
    #  self.class.database_attrs.each do |field|
    #     if !((changed_fields.include?(field) && send(field) != user.send(field)) || send(field) == user.send(field))
    #      return false
    #     end
    #  end
    #true
    #end
  
    def changed_database_values? user, changed_fields
      self.class.database_attrs.all? do |field|
        (changed_fields.include?(field) && send(field) != user.send(field)) || send(field) == user.send(field)
      end
    end

  end  
end