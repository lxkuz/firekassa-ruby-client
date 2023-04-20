# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Transactions API
  class Transaction < Client
    def show(id)
      path = "/api/v2/transactions/#{id}"
      send_request(method: :get, path: path)
    end

    def cancel(id)
      path = "/api/v2/transactions/#{id}/cancel"
      send_request(method: :post, path: path)
    end

    def list(filter: nil, page: nil, sort: nil)
      # TODO: add proper URI encode
      path = "/api/v2/transactions"
      send_request(method: :get, path: path)
    end

    def download_receipt(id)
      path = "/api/v2/transactions/#{id}/receipt"
      send_request(method: :get, path: path)
    end

    def send_to_email(id:, email:, format:)
      data = { email: email, format: format }
      path = "/api/v2/transactions/#{id}/send-receipt"
      send_request(method: :post, path: path, body: data)
    end
  end
end
