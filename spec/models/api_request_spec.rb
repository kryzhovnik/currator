require 'spec_helper'
require './currator'

RSpec.describe ApiRequest do
  let(:cache_value) { nil }
  let(:cache) { double('cache', 'read' => cache_value, 'write' => true) }

  before do
    allow(Currator).to receive(:cache).and_return(cache)
  end

  describe '.call' do
    before do
      allow(Alphavantage::Client).to receive(:get).and_return(response)
    end

    context 'when response is successful' do
      let(:response) { double('response', 'successful?' => true, 'rate' => '0.01') }

      it 'return rate' do
        expect(ApiRequest.call(from: 'usd', to: 'rub')).to eq({ rate: '0.01' })
      end

      it 'caches rate' do
        expect(cache).to receive(:write).with({ from: 'usd', to: 'rub' }, '0.01')
        ApiRequest.call(from: 'usd', to: 'rub')
      end
    end

    context 'when response hit api limit' do
      let(:response) {
        double('response', 'successful?' => false, 'hit_api_limit?' => true,
          'error_message' => nil)
      }

      context 'cache is empty' do
        it 'tries to read rate from cache and raise error' do
          expect(cache).to receive(:read).with(from: 'usd', to: 'rub')
          expect { ApiRequest.call(from: 'usd', to: 'rub') }
            .to raise_error(Currator::Error)
        end
      end

      context 'cache is empty' do
        let(:cache_value) { 'not null' }
        it 'tries to read rate from cache and raise error' do
          expect(cache).to receive(:read).with(from: 'usd', to: 'rub')
          expect(ApiRequest.call(from: 'usd', to: 'rub')).to eq({ rate: 'not null' })
        end
      end
    end

    context 'when response is not successful and does not hit api limit' do
      let(:response) {
        double('response', 'successful?' => false, 'hit_api_limit?' => false,
          'error_message' => 'Error from API')
      }

      it 'raise Currator::Error' do
        expect { ApiRequest.call(from: 'usd', to: 'rub') }
          .to raise_error(Currator::Error).with_message('Error from API')
      end
    end
  end
end
