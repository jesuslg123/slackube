require "uri"
require "net/http"

class SlackAPI

    def initialize(token)
        @token = token
    end

    def setStatus(text, emoji)
        puts "Slack, text: #{text}, emoji: #{emoji}"
        body = request_body(text, emoji)
        http_request(body)
    end

    def http_request(data)
        url = URI("https://slack.com/api/users.profile.set")

        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true
        
        request = Net::HTTP::Post.new(url)
        request["Content-type"] = " application/json; charset=utf-8"
        request["Authorization"] = "Bearer #{@token}"
        request.body = data.to_json
        
        response = https.request(request)
        puts response.read_body
    end

    def request_body(text, emoji)
        {
            profile: {
                status_emoji: emoji,
                status_text: text
            }
        }
    end

end