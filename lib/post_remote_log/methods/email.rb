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
require 'net/smtp'
require 'digest'

module PostRemoteLog
	module Methods

		class Email
			def self.send(config, values)
				message = PostRemoteLog.build_xml_message(values)

				email = StringIO.new
				marker = Digest::MD5.hexdigest(Time.now.to_s)

				from = "#{values[:user]}@#{values[:hostname]}"
				to = config[:to]

				email.puts "From: #{from}"
				email.puts "To: #{to}"
				email.puts "Subject: Remote Log: #{values[:classification]}"
				email.puts "MIME-Version: 1.0"
				email.puts "Content-Type: multipart/mixed; boundary=#{marker}"
				email.puts
				email.puts "--#{marker}"
				email.puts "Content-Type: text/plain"
				email.puts "Content-Transfer-Encoding: 8bit"
				email.puts
				email.puts "A remote log was created and sent at #{Time.now.to_s}. Here are the details:"
				
				[:classification, :user, :uptime, :system, :hostname, :address].each do |key|
					email.puts "\t#{key}: #{values[key]}"
				end
				
				email.puts
				
				email.puts values[:report]
				
				email.puts
				email.puts
				email.puts "--#{marker}"
				email.puts "Content-Type: text/xml; name=\"remote_log.xml\""
				email.puts "Content-Transfer-Encoding:base64"
				email.puts "Content-Disposition: attachment; filename=\"remote_log.xml\""
				email.puts
				
				email.puts [message.string].pack("m")
				
				email.puts
				email.puts "--#{marker}"
				email.puts "Content-Type: text/plain; name=\"report.txt\""
				email.puts "Content-Transfer-Encoding:base64"
				email.puts "Content-Disposition: attachment; filename=\"report.txt\""
				email.puts
				
				email.puts [values[:report]].pack("m")
				
				email.puts "--#{marker}--"

				smtp = Net::SMTP.new(config[:host], config[:port])
				
				begin
					if config[:tls]
						unless smtp.respond_to? :enable_starttls
							raise ArgumentError.new("STARTTLS is not supported by this version of Ruby.")
						end
						
						context = Net::SMTP.default_ssl_context
						context.verify_mode = OpenSSL::SSL::VERIFY_NONE
						
						smtp.enable_starttls(context)
					end
					
					smtp.start(values[:hostname], config[:user], config[:pass], config[:auth])
					
					smtp.sendmail(email.string, from, [to])
					
					$stderr.puts "Remote log created successfully."
				ensure
					smtp.finish
				end
			end
		end

	end
end

