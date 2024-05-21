# frozen_string_literal: true

require_relative "ruby_kafka_retry/version"

module RubyKafkaRetry
  class Error < StandardError; end

  class RetryFailedEvent

    def initialize(event_message, event_queue)
      @event_message = event_message
      @event_queue = event_queue
    end

    def retry
      p "*********************"
      p @event_message
      p @event_queue
    end

  end

end
