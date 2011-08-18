# Copyright (c) 2009, 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
