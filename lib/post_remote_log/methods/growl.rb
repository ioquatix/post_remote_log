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

require 'ruby-growl'

module PostRemoteLog
	module Methods

		class Growl
			def self.send(config, values)
				g = ::Growl.new(config[:host], "PostRemoteLog", [values[:classification]], [values[:classification]], config[:password])

				message = StringIO.new
				[:uptime, :system, :hostname, :address].each do |key|
					message.puts "[#{key}] #{values[key]}"
				end

				message.puts
				message.puts values[:report]

				g.notify(values[:classification], "Remote Log [#{values[:classification]}] from #{values[:hostname]}", message.string, config[:priority] || 0, config[:sticky])
			end
		end

		@@methods[:growl] = Growl

	end
end
