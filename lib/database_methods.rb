require 'pry'
require 'mysql2'

module DatabaseMethods

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend(ClassMethods)
  end
  

  module ClassMethods
    def sort_by_fields fields
      objects = client.query("SELECT * FROM #{self.table_name} ORDER BY #{fields.join(', ')}").to_a
      objects.map { |obj| self.new(obj) }
    end

    def all
      objects = client.query("SELECT * FROM #{self.table_name}").to_a
      objects.map {|data| self.new(data)}
    end

    def count
      #@@client.query("SELECT * FROM users").count
      client.query("SELECT COUNT(*) count FROM #{self.table_name}").to_a[0]['count']
    end

    def find_by_id id
      data = client.query("SELECT * FROM #{self.table_name} WHERE id = #{id}").to_a
      self.new(data[0])
    end

    def database_attrs
      return @@database_attrs if defined? @@database_attrs
      fields = client.query("DESC #{self.table_name}").to_a
      database_attrs = fields.map { |obj| obj["Field"] }
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
  
    def changed_database_values? user, changed_fields
      self.class.database_attrs.all? do |field|
        field = field.to_sym
        (changed_fields.include?(field) && send(field) != user.send(field)) || send(field) == user.send(field)
      end
    end

    def delete
      client.query("DELETE FROM #{self.class.table_name} WHERE id = #{id}")
    end

    def update params
      changing_attrs = params.map { |k, v| "#{k} = '#{v}'" }.join(', ')
      client.query("UPDATE #{self.class.table_name} SET #{changing_attrs} WHERE id = #{id} ")
    end

    def save
      fields = self.class.database_attrs
      fields.delete("id")
      values = fields.map { |f| "'#{send(f)}'" }
      client.query("INSERT INTO #{self.class.table_name} (#{fields.join(',')})
                        VALUES(#{values.join(', ')})")
      @id = client.last_id
      self
    end

  end  
end