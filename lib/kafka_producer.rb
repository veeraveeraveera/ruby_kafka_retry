class KafkaProducer

  def initialize
    @configs = YAML.load_file("#{Rails.root}/config/ruby_kafka_retry.yml")[Rails.env]
  end

  def get_kafka_instance
    Kafka.new(@configs["brokers"], client_id: @configs["client_id"], ssl_ca_certs_from_system: @configs["ssl_ca_certs_from_system"])
  end

  def publish_to_topic(topic, message)
    kafka = get_kafka_instance
    kafka.deliver_message(message.to_json, topic: topic)
  end
end
