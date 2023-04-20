# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Withdraw do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "wE5V6Jh51mdh3ZQ1LuJCDZC6Gw6SHvZ9curDSEBmdSjh8CDCS33puZJ71fGNgzmx"
    end
  end

  let(:withdraw) { described_class.new }

  xdescribe "#create" do
    subject(:result) { withdraw.create(withdraw_data) }

    let(:valid_withdraw_data) do
      {
        order_id: "12341",
        method: "card",
        amount: "1.0",
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

    let(:withdraw_response) do
      {
        "account" => "1234",
        "action" => "Withdraw",
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

    context "when transaction is valid", vcr: "Withdraw/create" do
      let(:withdraw_data) { valid_withdraw_data }

      it "returns Withdraw response" do
        expect(result).to eq(withdraw_response)
      end
    end

    context "when amount is too small", vcr: "withdraw/amount_is_too_small_error" do
      let(:withdraw_data) do
        valid_withdraw_data.merge({ amount: "1.0" })
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
          "amount" => "165.56",
          "message" => "Вывод на сумму: 165.56₽, по курсу: 1$ = 82.78₽",
          "rate" => "82.7800",
        }
      end

      it "returns currency rate response" do
        expect(result).to eq(response)
      end
    end
  end
end
