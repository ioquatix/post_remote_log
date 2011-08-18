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

require 'post_remote_log/xml'
require 'net/http'

module PostRemoteLog
	module Methods

		class XMLRPC
			def self.send(config, values)
				message = PostRemoteLog.build_xml_message(values)

				port = config[:port] || 9080
				path = config[:path] || "/post-remote-log"

				Net::HTTP.start(config[:host], port) do |http|
					response = http.post(path, message.string, {"Content-Type" => "text/xml"})

					unless (200...300).include?(response.code.to_i)
						$stderr.puts "Could not create remote log record..."

						$stderr.puts "Code: #{response.code}" 
						$stderr.puts "Message: #{response.message}"
						$stderr.puts "Body:\n #{response.body}"
					end
				end
			end
		end

		@@methods[:xmlrpc] = XMLRPC

	end
end
