require 'pry'

class Array
  #def equal_items? ads
  #  self.first.class.database_attrs.each do |f|
  #    i = 0
  #    #each_with_index
  #    each do |ad|
  #      if ad.send(f) != ads[i].send(f)
  #        return false
  #      end
  #      i += 1   
  #    end
  #  end
  #  true
  #end

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