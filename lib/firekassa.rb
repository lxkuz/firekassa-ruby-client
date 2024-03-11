# frozen_string_literal: true

require "firekassa/config"
require "firekassa/version"
require "firekassa/account"
require "firekassa/balance"
require "firekassa/transaction"
require "firekassa/deposit"
require "firekassa/withdraw"

# Head module
module Firekassa
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end
end
