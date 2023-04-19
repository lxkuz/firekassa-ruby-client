# frozen_string_literal: true

require "firekassa/config"
require "firekassa/client"

module Firekassa
  # Get site balance API
  class Balance < Client
    def get
      path = "/api/v2/balance"
      send_request(method: :get, path: path)
    end
  end
end
