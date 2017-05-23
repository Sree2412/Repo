#require_relative 'NtlmRest'
require 'httpclient'

class RestServiceBase
  attr_accessor :uri, :username, :password, :ntlm

  def initialize(url)
    self.uri = URI(url)
  end

  def set_auth(username, password)
    self.username = username
    self.password = password
  end

  def serviceCall(verb, data='')
        begin
            client = HTTPClient.new
            client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
            if !self.username.empty? && !self.password.empty?
                client.set_auth(nil, self.username, self.password)
            end
            if data.length > 0
                result = client.send(verb.downcase, self.uri.to_s, data, {"Content-Length" => data.length, "Content-Type" => "application/json"})
            else
                result = client.send(verb.downcase, self.uri.to_s)
            end
        return {body: result.body,code: result.status_code,response: result.reason}
        rescue Exception => e
            return {body: e, code: 500, response: e}
        end
  end

  def get
    return serviceCall("get")
  end

  def post(data)
    return serviceCall("post", data)
  end

  def put(data)
    return serviceCall("put", data)
  end

  def patch(data)
    return serviceCall("patch", data)
  end

  def delete
    return serviceCall("delete")
  end

end
