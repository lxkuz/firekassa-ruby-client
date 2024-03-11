# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Deposit do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "testtokenvalue"
    end
  end

  let(:deposit) { described_class.new }

  describe "#create_card" do
    subject(:result) { deposit.create_card(deposit_data) }

    let(:valid_deposit_data) do
      {
        order_id: "11_03_2024_18_37",
        amount: "100.0",
        site_account: "sber"
      }
    end

    let(:deposit_response) do
      {
        "amount" => "100.00",
        "card_number" => "4242424242424242",
        "commission" => "2.00",
        "first_name" => "test",
        "id" => "516551333",
        "last_name" => "test",
        "middle_name" => "test"
      }
    end

    context "when transaction is valid", vcr: "deposit/create_card" do
      let(:deposit_data) { valid_deposit_data }

      it "returns deposit response" do
        expect(result).to eq(deposit_response)
      end
    end

    context "when amount is too small", vcr: "deposit/amount_is_too_small_error" do
      let(:deposit_data) do
        valid_deposit_data.merge({ amount: "1.0" })
      end

      let(:error_data) do
        {
          "message" => "The given data was invalid",
          "errors" => {
            "amount" => ["Min amount is 100.00"]
          }
        }
      end

      it "returns validation error response", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end
  end
end
