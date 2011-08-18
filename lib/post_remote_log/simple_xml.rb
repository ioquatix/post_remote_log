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

require 'stringio'

module PostRemoteLog

	# Very simple XML builder to minimize dependencies:
	class SimpleXMLBuilder < StringIO
		X = {"<" => "&lt;", ">" => "&gt;"}

		def initialize
			super

			@level = 0
		end

		def instruct!
			self.puts '<?xml version="1.0" encoding="UTF-8"?>'
		end

		def value(name, value)
			value.gsub!(/<|>/) { |s| X[s] }
			self.puts tab +  "<#{name}>" + value.to_s + "</#{name}>"
		end

		def tag(name, &block)
			self.puts tab + "<#{name}>"
			@level += 1
			yield
			@level -= 1
			self.puts tab + "</#{name}>"
		end

		protected
		def tab
			("\t" * @level)
		end
	end
end
