require 'spec_helper'

RSpec.describe Validator do
  it "validates params" do
    validator = Validator.new(from: 'usd', to: 'rub')

    expect(validator).to receive(:validate_from)
    expect(validator).to receive(:validate_to)

    validator.validate!
  end

  context "when params is invalid" do
    let(:validator) { Validator.new(from: 'nif', to: 'nuf') }

    it "raises Validator::Error" do
      expect { validator.validate! }.to raise_error(Validator::Error)
    end

    it "sends error messages to an error object" do
      expect { validator.validate! }.to raise_error.with_message(/nif is not allowed/)
      expect { validator.validate! }.to raise_error.with_message(/nuf is not allowed/)
    end
  end
end
