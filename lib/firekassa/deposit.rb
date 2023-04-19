# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Get site deposit API
  class Deposit < Client
    def create(data)
      path = "/api/v2/deposit"
      send_request(method: :post, path: path, body: data)
    end

    def show(id)
      path = "/api/v2/transactions/#{id}"
      send_request(method: :get, path: path)
    end
  end
end
