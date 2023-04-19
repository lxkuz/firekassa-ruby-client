# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Balance do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "KXJhTeRZfh11gvXvy7KAe6UsCxD2Dh4SW4jDfBzvzh9WhhcEoaJGQ8EA4ufgnbQ1"
    end
  end

  let(:balance) { described_class.new }

  describe "#get" do
    subject(:result) { balance.get }

    let(:balance_data) do
      {
        "balance" => "0.00"
      }
    end

    context "when transaction is valid", vcr: "balance/get" do
      it "returns site balance" do
        expect(result).to eq(balance_data)
      end
    end
  end
end
