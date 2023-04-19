# frozen_string_literal: true

module Firekassa
  # Configuration storage
  class Config
    attr_accessor :base_url, :api_token

    def initialize
      @base_url = nil
      @api_token = nil
      @faraday_block = nil
    end
  end
end
