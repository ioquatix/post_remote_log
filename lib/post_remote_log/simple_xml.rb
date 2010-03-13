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
