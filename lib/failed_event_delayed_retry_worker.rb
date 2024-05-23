require_relative "kafka_producer"

class FailedEventDelayedRetryWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'failed_event_delayed_retry'

  def perform(topic, message)
    KafkaProducer.new.publish_to_topic(topic, message)
  end

end
