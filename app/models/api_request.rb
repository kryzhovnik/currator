class ApiRequest
  def self.call(from:, to:)
    new(from: from, to: to).result
  end

  attr_reader :response, :to, :from

  def initialize(from:, to:)
    @from, @to = from, to
    @response = Alphavantage::Client.get(to: to, from: from)
  end

  def result
    if rate
      return { rate: rate }
    else
      raise Currator::Error.new(response.error_message || "Currator unexpected service error")
    end
  end

  private
    def rate
      if response.successful?
        Currator.cache.write({ to: to, from: from }, response.rate)

        return response.rate
      end

      if response.hit_api_limit?
        return Currator.cache.read(to: to, from: from)
      end

      nil
    end
end
