# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Deposit do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "wE5V6Jh51mdh3ZQ1LuJCDZC6Gw6SHvZ9curDSEBmdSjh8CDCS33puZJ71fGNgzmx"
    end
  end

  let(:deposit) { described_class.new }

  describe "#create" do
    subject(:result) { deposit.create(deposit_data) }

    let(:valid_deposit_data) do
      {
        order_id: "123",
        method: "wallet-card",
        amount: "5000.0",
        account: "12345",
        notification_url: "http://some.url/callback",
        success_url: "http://some.url/callback",
        fail_url: "http://some.url/callback",
        card_number: "4242424242424242",
        card_expire: "01/25",
        card_cvv: "123",
        ext_txn: "123",
        ext_date: "2020-01-01T00:00:00+03:00",
        ext_email: "test@mail.com",
        ext_ip: "127.0.0.1",
        ext_recipient_system: "Payeer EUR",
        ext_recipient: "P121321",
        ext_c_to: "PREUR",
        card_type: "visa"
      }
    end

    let(:deposit_response) do
      {
        "account" => "12345",
        "action" => "deposit",
        "amount" => "5000.00",
        "comment" => nil,
        "commission" => "25.00",
        "created_at" => "2023-04-19T17:29:00+03:00",
        "currency" => "RUB",
        "id" => "507122561",
        "method" => "wallet-card",
        "order_id" => "123",
        "payment_amount" => "0.00",
        "payment_code" => nil,
        "payment_error" => nil,
        "payment_error_code" => nil,
        "payment_id" => "332529680",
        "payment_url" => nil,
        "status" => "process",
        "updated_at" => "2023-04-19T17:29:01+03:00"
      }
    end

    context "when transaction is valid", vcr: "deposit/create" do
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
            "amount" => ["Min amount is 5000.00"]
          }
        }
      end

      it "returns validation error response", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end

    context "when wrong method", vcr: "deposit/wrong_method_error" do
      let(:deposit_data) do
        valid_deposit_data.merge({ method: "wrong" })
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

  describe "#show" do
    subject(:result) { deposit.show(deposit_id) }

    context "when transaction ID is valid", vcr: "deposit/show" do
      let(:deposit_id) { "507122561" }

      let(:deposit_response) do
        {
          "account" => "12345",
          "action" => "deposit",
          "amount" => "5000.00",
          "comment" => nil,
          "commission" => "25.00",
          "created_at" => "2023-04-19T17:29:00+03:00",
          "currency" => "RUB",
          "id" => "507122561",
          "method" => "wallet-card",
          "order_id" => "123",
          "payment_amount" => "0.00",
          "payment_code" => nil,
          "payment_error" => nil,
          "payment_error_code" => nil,
          "payment_id" => "332529680",
          "payment_url" => nil,
          "status" => "process",
          "updated_at" => "2023-04-19T17:29:01+03:00"
        }
      end

      it "returns deposit response" do
        expect(result).to eq(deposit_response)
      end
    end

    context "when transaction not found", vcr: "deposit/show_not_found_error" do
      let(:deposit_id) { "9999299990" }

      let(:error_data) do
        {
          "error" => "Transaction not exists"
        }
      end

      it "returns deposit not found error", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end
  end
end
