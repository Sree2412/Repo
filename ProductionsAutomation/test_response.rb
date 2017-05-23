require 'net/http'

# $env = ENV["RSPEC_ENV"]
url = 'http://www.google.com'
res = Net::HTTP.get_response(URI.parse(url.to_s))
puts res.code
