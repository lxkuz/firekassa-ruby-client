# frozen_string_literal: true

require "firekassa/config"
require "firekassa/version"
require "firekassa/balance"

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
