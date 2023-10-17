# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Invoice do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "wE5V6Jh51mdh3ZQ1LuJCDZC6Gw6SHvZ9curDSEBmdSjh8CDCS33puZJ71fGNgzmx"
    end
  end

  let(:invoice) { described_class.new }

  describe "#create" do
    subject(:result) { invoice.create(invoice_data) }

    let(:valid_invoice_data) do
      {
        "order_id": "21231231",
        "payment_methods": ["card"],
        "amount": "120.0",
        "notification_url": "http://some.url/callback",
        "success_url": "http://some.url/callback",
        "fail_url": "http://some.url/callback"
      }
    end

    let(:invoice_response) do
      {
        "id" => "511727028",
        "payment_url" => "https://pay.castelvania.net/69d039ce-ef4f-4da8-b28f-48e71c203417",
      }
    end

    context "when transaction is valid", vcr: "invoice/create" do
      let(:invoice_data) { valid_invoice_data }

      it "returns invoice response" do
        expect(result).to eq(invoice_response)
      end
    end
  end
end
