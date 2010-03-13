
module PostRemoteLog
	
	# Builds an XML formatted message from the supplied values
	def self.build_xml_message (values)
		message = SimpleXMLBuilder.new

		message.instruct!

		message.tag("remote_log") do
			[:classification, :uptime, :system, :hostname, :address, :report].each do |key|
				message.value key.to_s, values[key]
			end
		end

		return message
	end

	
end