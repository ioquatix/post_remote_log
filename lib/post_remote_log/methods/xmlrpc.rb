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