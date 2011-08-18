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

				port = 25

				if config[:tls]
					port = 587
				end

				port = config[:port] || port

				smtp = Net::SMTP.new(config[:host], port)

				begin
					if config[:tls]
						unless smtp.respond_to? :enable_starttls
							raise ArgumentError.new("STARTTLS is not supported by this version of Ruby.")
						end

						context = Net::SMTP.default_ssl_context
						context.verify_mode = OpenSSL::SSL::VERIFY_NONE

						smtp.enable_starttls(context)
					end

					auth = config[:auth] ? config[:auth].to_sym : nil
					auth ||= :plain if config[:password]

					smtp.start(values[:hostname], config[:user], config[:password], auth)

					smtp.sendmail(email.string, from, [to])
				ensure
					if smtp.started?
						smtp.finish
					end
				end
			end
		end

		@@methods[:email] = Email

	end
end
