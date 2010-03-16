
module PostRemoteLog
	
	module Methods
		@@methods = {}
		
		def self.load_method(name)
			name = name.to_sym

			unless @@methods[name]
				require File.join(File.dirname(__FILE__), "methods", name.to_s)
			end

			return @@methods[name]
		end
	end
	
end