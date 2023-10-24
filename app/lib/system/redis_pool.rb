# frozen_string_literal: true

require 'connection_pool'

module System
  # RedisPool a simple wrapper around Redis with connection pooling
  class RedisPool

    def initialize(config = {})
      cfg = config.to_h
      pool_config = cfg.extract!(:size, :pool_timeout)
      @pool = ConnectionPool.new(size: pool_config[:size] || 5, timeout: pool_config[:pool_timeout] || 5 ) do
        Redis.new(cfg)
      end
    end

    # This class only respond to public methods of Redis
    def respond_to_missing?(method_sym, _include_private = false)
      @pool.with do |conn|
        conn.respond_to?(method_sym, false)
      end
    end

    def method_missing(method_sym, *args, &block)
      @pool.with do |conn|
        conn.public_send(method_sym, *args, &block)
      end
    end
  end
end
