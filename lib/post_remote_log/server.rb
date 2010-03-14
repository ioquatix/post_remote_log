# Copyright (c) 2009 Samuel Williams. Released under the GNU GPLv3.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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