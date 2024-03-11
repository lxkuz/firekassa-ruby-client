# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Deposit API
  class Deposit < Client
    def create(type, data)
      path = "/api/v2/deposit/#{type}"
      send_request(method: :post, path: path, body: data)
    end

    def create_card(data)
      create(:card, data)
    end

    def create_sbp(data)
      create(:sbp, data)
    end

    def create_sbpa(data)
      create("sbp-a", data)
    end

    def create_usdt_trc20(data)
      create("usdt-trc20", data)
    end

    def create_usdt_erc20(data)
      create("usdt-erc20", data)
    end
  end
end
