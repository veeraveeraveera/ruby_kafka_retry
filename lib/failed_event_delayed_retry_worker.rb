require_relative "kafka_producer"

class FailedEventDelayedRetryWorker
  include Sidekiq::Worker

  def perform(topic, message)
    KafkaProducer.new.publish_to_topic(topic, message)
  end

end
