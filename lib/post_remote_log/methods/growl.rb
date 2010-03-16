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

require 'ruby-growl'

module PostRemoteLog
	module Methods

		class Growl
			def self.send(config, values)
				g = ::Growl.new(config[:host], "PostRemoteLog", [values[:classification]], [values[:classification]], config[:password])
				
				message = StringIO.new
				[:classification, :uptime, :system, :hostname, :address].each do |key|
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