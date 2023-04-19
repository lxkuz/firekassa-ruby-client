# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Get site withdraw API
  class Withdraw < Client
    def create(data)
      path = "/api/v2/withdrawal"
      send_request(method: :post, path: path, body: data)
    end

    def show(id)
      path = "/api/v2/transactions/#{id}"
      send_request(method: :get, path: path)
    end
  end
end
