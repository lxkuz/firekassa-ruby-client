# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Account do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "wE5V6Jh51mdh3ZQ1LuJCDZC6Gw6SHvZ9curDSEBmdSjh8CDCS33puZJ71fGNgzmx"
    end
  end

  let(:account) { described_class.new }

  describe "#list" do
    subject(:result) { account.list }

    let(:accounts_data) do
      {
        "items" => [{ "balance" => "0.00", "commission" => "0.00", "currency" => "RUB", "id" => "18",
                      "is_default" => true }],
        "page" => { "number" => 1, "size" => 1 }
      }
    end

    context "when request is valid", vcr: "account/get" do
      it "returns site accounts list" do
        expect(result).to eq(accounts_data)
      end
    end
  end

  describe "#show" do
    subject(:result) { account.show(account_id) }

    let(:account_data) do
      {
        "balance" => "0.00",
        "commission" => "0.00",
        "currency" => "RUB",
        "id" => "18",
        "is_default" => true
      }
    end

    context "when request is valid", vcr: "account/show" do
      let(:account_id) { "18" }

      it "returns site accounts list" do
        expect(result).to eq(account_data)
      end
    end
  end
end
