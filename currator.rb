require './config/environment'

class Currator < Sinatra::Base
  class Error < StandardError; end

  @@logger = Logger.new("logs/#{environment}.log")
  @@cache = Cache.new

  def self.logger
    @@logger
  end

  def self.cache
    @@cache
  end

  configure :development do
    register Sinatra::Reloader

    also_reload 'models/**/*.rb'
  end

  get('/:from/:to/?') do
    begin
      Validator.new(params).validate!

      response = ApiRequest.call(from: params[:from], to: params[:to])

      json status: 'ok', rate: response[:rate]
    rescue Currator::Error, Validator::Error, Alphavantage::Client::Error => exception
      json status: 'error', errors: render_error_message(exception)
    end
  end

  private
    def render_error_message(e)
      if e.message && e.message.size > 0
        e.message
      else
        "Currator unexpected service error"
      end
    end
end
