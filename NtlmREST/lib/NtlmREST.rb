require 'socket'
require 'net/ntlm'
require 'uri'

class NtlmREST
	attr_accessor :socket, :uri, :username, :password
	
	def readMessage
		length = 0
		content = ""
		while(line = self.socket.gets)
			
			if /^WWW-Authenticate: (NTLM|Negotiate) (.+)\r\n/ =~ line
				msg = $2
			end
			
			if /^Content-Length: (\d+)\r\n/ =~ line
				length = $1.to_i
			end
			if /^\r\n/ =~ line
				if length > 0
					content += self.socket.read(length)
				end
				break
			end
		end
		return { "body": content, "length": content.length, "message-type": msg }
	end
    
	def append_header(verb)
		self.socket.print "#{verb} #{self.uri.path} HTTP/1.1\r\n"
		self.socket.print "Host: #{self.uri.host}\r\n"
		self.socket.print "Keep-Alive: 300\r\n"
		self.socket.print "Connection: keep-alive\r\n"
	end

	def append_data_header(dataLen)
		self.socket.print "Content-Type: application/json;charset=utf-8\r\n"
		self.socket.print "Content-Length: #{dataLen}\r\n"
		self.socket.print "Accept: application/json, text/plain, */*\r\n"
		self.socket.print "Accept-Encoding: gzip, deflate\r\n"
	end

	def post_body(data)
		self.socket.print data
	end
	
	def startNegotiation
		t1 = Net::NTLM::Message::Type1.new()
		append_header("GET")
		self.socket.print "Authorization: NTLM " + t1.encode64 + "\r\n"
		self.socket.print "\r\n"
		return Net::NTLM::Message.decode64(self.readMessage()[:"message-type"])
	end
    
	def buildReturnTag(data)
		if data.include?"</html>"
			startIndex = (data.index("<title>") + 7)
			error = data[startIndex, data.index("</title>") - startIndex]
			return {body: data, code: error[0,3], response: error[6,error.length-6]}
		else
			return {body: data, code: 200, response: "ResultOK"}
		end
	end
    
    def getString(verb, data=nil)
        begin
            self.socket = TCPSocket.new(self.uri.host, self.uri.port)
            msg = startNegotiation
            t3 = msg.response({:user => self.username, :password => self.password}, {:ntlmv2 => true})
            append_header(verb.upcase)
            if data != nil
                append_data_header(data.length)
            end
            self.socket.print "Authorization: NTLM " + t3.encode64 + "\r\n"
            self.socket.print "\r\n"
            post_body(data)
            value = self.readMessage()
            self.socket.close
            return buildReturnTag(value[:body])
        rescue Exception => e 
            return {body: e, code: 500, response: e}
        end
    end
    	
    public
    def initialize
        self.username = ""
        self.password = ""
    end
    
	def set_auth(username, password)
		self.username = username
		self.password = password	
	end
	
	def get(url)
        self.uri = URI(url)
        return getString("get")
	end
	
	def post(url, data)
		self.uri = URI(url)
		return getString("post", data)
	end
	
	def put(url, data)
		self.uri = URI(url)
		return getString("put", data)
	end
	
	def patch(url, data)
		self.uri = URI(url)
		return getString("patch", data)
	end
	
	def delete(url, data)
		raise "Delete method not yet implemented"
		#self.uri = URI(url)
		#return getString("delete", data)
	end
end