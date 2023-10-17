# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Invoice API
  class Invoice < Client
    def create(data)
      path = "/api/v2/invoices"
      send_request(method: :post, path: path, body: data)
    end
  end
end
