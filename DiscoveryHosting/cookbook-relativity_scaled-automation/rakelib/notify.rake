desc 'Notify in Slack'
task :slack do
  channel = if ENV['channel']
              ENV['channel']
            else
              '@kxmoss'
            end
  message = if ENV['message']
              ENV['message']
            else
              'test'
            end
  uri = URI.parse(
    'https://hooks.slack.com/services/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'
  )
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  data = {
    text: message.to_s,
    channel: channel.to_s
  }
  request = Net::HTTP::Post.new(uri.request_uri)
  request.add_field('Content-Type', 'application/json')
  request.body = data.to_json
  http.request(request)
end
