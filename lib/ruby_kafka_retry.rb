# frozen_string_literal: true

require_relative "ruby_kafka_retry/version"
require_relative "ruby_kafka_retry_validator"
require_relative "kafka_producer"
require_relative "sidekiq_publisher"

module RubyKafkaRetry
  class Error < StandardError; end
  class RetryFailedEvent

    def initialize(retry_topic, dlq_topic, topic_message, max_retry_attempt=3)
      @retry_topic = retry_topic
      @dlq_topic = dlq_topic
      @topic_message = topic_message
      @max_retry_attempt = max_retry_attempt
    end

    def validate_params
      RubyKafkaRetryValidator.new(@retry_topic, @dlq_topic, @topic_message).validate
    end

    def can_add_dlq_topic?(curr_retry_attempt)
      @max_retry_attempt < curr_retry_attempt
    end

    def format_message
      @topic_message['current_retry_attempt'] = @topic_message['current_retry_attempt'].to_i + 1
      @topic_message
    end

    def process_message
      message = format_message
      if(can_add_dlq_topic?(message['current_retry_attempt']))
        KafkaProducer.new.publish_to_topic(@dlq_topic, message)
      else
        SidekiqPublisher.new.publish_to_sidekiq(@retry_topic, message)
      end
    end

    def retry
      validate_params
      process_message
      return true
    end

  end

end
