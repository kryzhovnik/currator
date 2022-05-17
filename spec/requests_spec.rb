require './currator'

require 'rspec'
require 'rack/test'
require 'spec_helper'

ENV['ALPHAVANTAGE_API_KEY'] = 'test'

RSpec.describe Currator do
  include Rack::Test::Methods

  def app
    Currator
  end

  before(:all) {
    json = YAML.load_file('spec/fixtures/alphavantage.yml').to_json
    @fixures = JSON.parse(json, object_class: OpenStruct)
  }
  let(:alphavantage) { @fixures }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Alphavantage::Client.class_variable_get :@@connection }
  let(:last_response_json) { JSON.parse(last_response.body) }

  before do
    connection.adapter(:test, stubs)
  end

  after do
    Faraday.default_connection = nil
  end

  it "responses successfuly on valid request" do
    req_resp = alphavantage['usd/rub-success']
    stubs.get(req_resp[:url]) do |env|
      [
        200,
        { 'Content-Type': 'application/javascript' },
        req_resp[:body]
      ]
    end

    get "usd/rub"
    expect(last_response).to be_ok
    expect(last_response.body).to eq('{"status":"ok","rate":"64.25000000"}')
  end

  it "responses with error on invalid request" do
    get "nif/nuf"
    expect(last_response).to be_ok
    expect(last_response_json['status']).to eq("error")
  end
end
