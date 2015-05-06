require 'pry'

class Hash
	def symbolize_keys!
		keys.each {|k| self[k.to_sym] = delete(k)}
		self
	end

	#def equal_values? obj
	#	each do |k, v| 
	#		if v != obj.send(k) 
	#		   return false
	#	  end
	#  end
  # true
	#end

	#def equal_values? obj
	#	map {|k, v| v == obj.send(k)}
	#	!include?(false)
	#end


	#def equal_values? obj
	#	!any? {|k, v| v != obj.send(k)}
	#end

	
	def equal_values? obj
		all? {|k, v| v == obj.send(k)}
	end
end



#any?
#all?Q