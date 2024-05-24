require_relative "failed_event_delayed_retry_worker"

class SidekiqPublisher

  def initialize
    @configs = YAML.load_file("#{Rails.root}/config/ruby_kafka_retry.yml")[Rails.env]
  end

  def configure_sidekiq_server
    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://' + @configs['redis_host'] + ':' + @configs['redis_port'].to_s + '/' + @configs['redis_db'].to_s}
    end
    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://' + @configs['redis_host'] + ':' + @configs['redis_port'].to_s + '/' + @configs['redis_db'].to_s}
    end
  end

  def get_delay_time(current_retry_attempt)
    2 ** current_retry_attempt
  end

  def publish_to_sidekiq(topic, message)
    configure_sidekiq_server
    delay_time = get_delay_time(message['current_retry_attempt'])
    FailedEventDelayedRetryWorker.set(queue: @configs['sidekiq_queue']).perform_in(delay_time.minutes, topic, message)
  end
end
