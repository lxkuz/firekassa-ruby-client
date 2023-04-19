# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Site accounts API
  class Account < Client
    def list
      path = "/api/v2/accounts"
      send_request(method: :get, path: path)
    end

    def show(id)
      path = "/api/v2/accounts/#{id}"
      send_request(method: :get, path: path)
    end
  end
end
