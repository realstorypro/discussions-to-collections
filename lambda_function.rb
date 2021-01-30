require 'json'
require 'httparty'
require 'dotenv/load'

def lambda_handler(event:, context:)
    response = HTTParty.get('https://pub.storypro.io/feed.json')
    entries = JSON.parse(response.body)['entries']

    discussions = []

    entries.each do |entry|
        discussions.push entry if entry['type'] == 'Discussion'

    end

    request_body = {
      name: 'discussions',
      data: discussions
    }

    rsp = HTTParty.put('https://beta-api.customer.io/v1/api/collections/1',
        body: request_body.to_json,
        headers: {
            "Authorization" => "Bearer #{ENV['API_KEY']}"
        }

    )

    puts ENV['API_KEY'], rsp


    { statusCode: 200, body: discussions.to_json }
end

lambda_handler(event: 'hi', context: 'bye')