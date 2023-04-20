# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Withdraw API
  class Withdraw < Client
    def create(data)
      path = "/api/v2/withdrawal"
      send_request(method: :post, path: path, body: data)
    end

    def currency_rate(data)
      path = "/api/v2/withdrawal/rate"
      send_request(method: :post, path: path, body: data)
    end
  end
end
