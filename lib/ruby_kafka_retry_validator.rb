class RubyKafkaRetryValidator
  include ActiveModel::Validations

  attr_accessor :original_topic, :retry_topic, :dlq_topic, :message

  validate :validate_retry_topic
  validate :validate_dlq_topic
  validate :validate_message

  def initialize(retry_topic, dlq_topic, message)
    @retry_topic = retry_topic
    @dlq_topic = dlq_topic
    @message = message
  end

  def validate
    validate_retry_topic
    validate_dlq_topic
    validate_message
  end

  def validate_retry_topic
    raise "Validation failed: Retry topic shouldn't be blank" unless retry_topic.present?
  end

  def validate_dlq_topic
    raise "Validation failed: DLQ topic shouldn't be blank" unless dlq_topic.present?
  end

  def validate_message
    raise "Validation failed: Topic message must be a non-empty Hash" unless(message.present? && message.is_a?(Hash))
  end

end
