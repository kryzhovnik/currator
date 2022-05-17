# frozen_string_literal: true

module Alphavantage
  class Error < StandardError; end

  class Client
    @@connection = Faraday.new(
      url: 'https://www.alphavantage.co',
      params: { function: 'CURRENCY_EXCHANGE_RATE', apikey: ENV['ALPHAVANTAGE_API_KEY'] },
      headers: { 'Content-Type' => 'application/json' })

    def self.get(to:, from:)
      response = @@connection.get('/query') do |req|
        req.params['from_currency'] = from
        req.params['to_currency'] = to
      end

      if response.success?
        Response.new(response.body)
      else
        raise Alphavantage::Error.new("Alphavantage API response is not successful (status != 200)")
      end
    end
  end
end
