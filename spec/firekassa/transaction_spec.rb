# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Transaction do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "wE5V6Jh51mdh3ZQ1LuJCDZC6Gw6SHvZ9curDSEBmdSjh8CDCS33puZJ71fGNgzmx"
    end
  end

  let(:transaction) { described_class.new }

  describe "#show" do
    subject(:result) { transaction.show(transaction_id) }

    context "when transaction ID is valid", vcr: "transaction/show" do
      let(:transaction_id) { "507122561" }

      let(:transaction_response) do
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

      it "returns transaction response" do
        expect(result).to eq(transaction_response)
      end
    end

    context "when transaction not found", vcr: "transaction/show_not_found_error" do
      let(:transaction_id) { "9999299990" }

      let(:error_data) do
        {
          "error" => "Transaction not exists"
        }
      end

      it "returns transaction not found error", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end
  end

  describe "#cancel" do
    subject(:result) { transaction.show(transaction_id) }

    context "when transaction ID is valid", vcr: "transaction/cancel" do
      let(:transaction_id) { "507122561" }

      let(:transaction_response) do
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
          "status" => "expired",
          "updated_at" => "2023-04-19T18:29:03+03:00"
        }
      end

      it "returns transaction response" do
        expect(result).to eq(transaction_response)
      end
    end

    context "when transaction not found", vcr: "transaction/cancel_not_found_error" do
      let(:transaction_id) { "9999299990" }

      let(:error_data) do
        {
          "error" => "Transaction not exists"
        }
      end

      it "returns transaction not found error", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end
  end

  describe "#list" , vcr: "transaction/list" do
    subject(:result) { transaction.list }

    let(:response) do
      {
        "items" => [{"account"=>"9222", "action"=>"deposit", "amount"=>"20.00", "comment"=>nil, "commission"=>"0.10", "created_at"=>"2023-04-20T18:47:01+03:00", "currency"=>"RUB", "id"=>"507164249", "method"=>"wallet-card", "order_id"=>"911", "payment_amount"=>"0.00", "payment_code"=>nil, "payment_error"=>nil, "payment_error_code"=>nil, "payment_id"=>"332538830", "payment_url"=>nil, "status"=>"expired", "updated_at"=>"2023-04-20T19:47:06+03:00"}, {"account"=>"12345", "action"=>"deposit", "amount"=>"5000.00", "comment"=>nil, "commission"=>"25.00", "created_at"=>"2023-04-19T17:29:00+03:00", "currency"=>"RUB", "id"=>"507122561", "method"=>"wallet-card", "order_id"=>"123", "payment_amount"=>"0.00", "payment_code"=>nil, "payment_error"=>nil, "payment_error_code"=>nil, "payment_id"=>"332529680", "payment_url"=>nil, "status"=>"expired", "updated_at"=>"2023-04-19T18:29:03+03:00"}],
        "page" => {"number"=>1, "size"=>20},
      }
    end

    it "returns transaction response" do
      expect(result).to eq(response)
    end
  end

  xdescribe "#download_receipt" do
  end


  xdescribe "#send_to_email" do
  end
end
