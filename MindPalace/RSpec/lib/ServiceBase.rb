require 'httpclient'

class ServiceBase
  attr_accessor :uri

  def initialize(url)
    self.uri = URI(url)
  end

  def serviceCall(verb, data)
        begin
            client = HTTPClient.new
            #client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
            if data.length > 0
                result = client.send(verb.downcase, self.uri.to_s, data, {"Content-Type" => "application/json;charset=utf-8"})
            else
                result = client.send(verb.downcase, self.uri.to_s)
            end
        return {body: result.body,code: result.status_code,response: result.reason}
        rescue Exception => e
            return {body: e, code: 500, response: e}
        end
  end

  def get
    return serviceCall("get",'')
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
