
require 'fileutils'
require 'time'

module PostRemoteLog
	
	class Server
		def initialize(config = {})
			@dump_dir = config[:dump_path]
			
			$stderr.puts "Dumping data to #{@dump_dir}"
			FileUtils.mkdir_p(@dump_dir)
		end
		
		def call(env)
			request = Rack::Request.new(env)
			
			if request.post?
				data = request.body().read()
				
				now = Time.now
				file_name = "#{now.strftime('%Y%m%d_%H%M%S')}_#{now.usec}.xml"
				full_path = File.join(@dump_dir, file_name)
				
				$stderr.puts "Writing data to #{file_name}..."
				
				File.open(full_path, "w") { |f| f.write(data) }
			end
			
			return [200, {}, []]
		end
	end
	
end