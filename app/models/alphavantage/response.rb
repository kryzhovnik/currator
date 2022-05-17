# frozen_string_literal: true

module Alphavantage
  class Response
    attr_reader :json

    def initialize(body)
      @json = JSON.parse(body)
    rescue JSON::ParserError
      raise Alphavantage::Error.new("Cant't parse Alphavantage respose")
    end

    def rate
      @rate ||= @json.dig('Realtime Currency Exchange Rate', '5. Exchange Rate')
    end

    def successful?
      !!rate
    end

    def hit_api_limit?
      @json.has_key?('Note') && \
        @json['Note'].start_with?("Thank you for using Alpha Vantage! Our standard API call frequency is")
    end

    def error_message
      @json['Error Message'] || @json['Note']
    end
  end
end
