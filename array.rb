require 'pry'

class Array
  def equal_items? ads
    self.first.class.database_attrs.each do |f|
      each_with_index do |obj, i|
        if obj.send(f) != ads[i].send(f)
          return false
        end  
      end
    end
    true
  end
end