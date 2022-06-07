require 'json'
require 'httparty'
require 'dotenv/load'
# require 'byebug'

def lambda_handler(event:, context:)
    response = HTTParty.get('https://www.nextweb.art/feed.json')
    entries = JSON.parse(response.body)['entries']

    discussions = []

    entries.each do |entry|
        discussions.push entry if entry['type'] == 'Discussion'

    end

    # 1. get the most recent discussion
    recent_discussions = discussions.shift(1)

    # 2. shuffle the remaining discussions
    discussions.shuffle!

    # 3. push the 4 discussions to shuffled discussions
    recent_discussions.push *discussions.shift(4)


    # request_body = {
    #   name: 'discussions',
    #   data: discussions
    # }

    request_body = {
      data: recent_discussions
    }

    rsp = HTTParty.put('https://beta-api.customer.io/v1/api/collections/1',
                       body: request_body.to_json,
                       headers: {
                           "Authorization" => "Bearer #{ENV['API_KEY']}"
                       }

    )

    { statusCode: 200, body: recent_discussions.to_json }
end

# lambda_handler(event: 'hi', context: 'bye')
