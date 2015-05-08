module DatabaseMethods
  #def equal_database_values? user
  #   self.class::DATABASE_ATTRS.all? {|v| send(v) == user.send(v)}
  #end

  def equal_database_values? user
    self.class.database_attrs.all? {|v| send(v) == user.send(v)} 
  end

  def change_database_values? user, changed_fields
    User.database_attrs.each do |field|
       if !((changed_fields.include?(field) && send(field) != user.send(field)) || send(field) == user.send(field))
        return false
       end
    end
  true
  end

end