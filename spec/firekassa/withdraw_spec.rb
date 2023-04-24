# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Withdraw do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "8ub1ReV5EwrZDLQS3LkwgQ19r1muidGYcPMBuvVt7VDFBGKwoeWXTg8mohZXFMu8"
    end
  end

  let(:withdraw) { described_class.new }

  describe "#create" do
    subject(:result) { withdraw.create(withdraw_data) }

    let(:valid_withdraw_data) do
      {
        order_id: "9911_4",
        method: "card",
        account: "4242424242424242",
        amount: "22.00",
        notification_url: "http://some.url/callback",
        success_url: "http://some.url/callback",
        fail_url: "http://some.url/callback"
      }
    end

    let(:withdraw_response) do
      {
        "account" => "4242424242424242",
        "action" => "withdrawal",
        "amount" => "22.00",
        "comment" => nil,
        "commission" => "50.44",
        "created_at" => "2023-04-24T17:37:39+03:00",
        "currency" => "RUB",
        "id" => "507311510",
        "method" => "card",
        "order_id" => "9911_4",
        "payment_amount" => "0.00",
        "payment_code" => nil,
        "payment_error" => nil,
        "payment_error_code" => nil,
        "payment_id" => "363092417",
        "payment_url" => nil,
        "status" => "process",
        "updated_at" => "2023-04-24T17:37:39+03:00",
      }
    end

    context "when transaction is valid", vcr: "withdraw/create" do
      let(:withdraw_data) { valid_withdraw_data }

      it "returns Withdraw response" do
        expect(result).to eq(withdraw_response)
      end
    end

    context "when amount is too small", vcr: "withdraw/amount_is_too_small_error" do
      let(:withdraw_data) do
        valid_withdraw_data.merge({ amount: "1.00" })
      end

      let(:error_data) do
        {
          "message" => "The given data was invalid",
          "errors" => {
            "amount" => ["Min amount is 10.00."]
          }
        }
      end

      it "returns validation error response", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end

    context "when wrong method", vcr: "withdraw/wrong_method_error" do
      let(:withdraw_data) do
        valid_withdraw_data.merge({ method: "wrong" })
      end

      let(:error_data) do
        {
          "message" => "Validation failed",
          "errors" => {
            "method" => ["Выбранное Вами значение недопустимо."]
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

  describe "#currency_rate" do
    subject(:result) { withdraw.currency_rate(request_data) }

    context "when request_data is valid", vcr: "withdraw/currency_rate" do
      let(:request_data) do
        {
          "method" => "contact",
          "account" => "CFRN",
          "amount" => "2.00",
          "currency" => "USD"
        }
      end

      let(:response) do
        {
          "amount" => "165.04",
          "message" => "Вывод на сумму: 165.04₽, по курсу: 1$ = 82.52₽",
          "rate" => "82.5200",
        }
      end

      it "returns currency rate response" do
        expect(result).to eq(response)
      end
    end
  end
end
