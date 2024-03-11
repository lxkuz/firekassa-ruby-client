# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Withdraw API
  class Withdraw < Client

    def create_card(data)
      create(:card, data)
    end

    def create_sbp(data)
      create(:sbp, data)
    end

    def create_phone(data)
      create(:phone, data)
    end

    def create_qiwi_wallet(data)
      create('qiwi-wallet', data)
    end

    def create_yoomoney(data)
      create(:yoomoney, data)
    end

    def create_usdt_trc20(data)
      create('usdt-trc20', data)
    end

    def create_usdt_erc20(data)
      create('usdt-erc20', data)
    end

    def sbp_banks
      paht = '/api/v2/sbp-banks'
      send_request(method: :get, path: paht)
    end

    private

    def create(type, data)
      path = "/api/v2/withdrawal/#{type}"
      send_request(method: :post, path: path, body: data)
    end
  end
end
