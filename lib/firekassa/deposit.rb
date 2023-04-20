# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Deposit API
  class Deposit < Client
    def create(data)
      path = "/api/v2/deposit"
      send_request(method: :post, path: path, body: data)
    end
  end
end
