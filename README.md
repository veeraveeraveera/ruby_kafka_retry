# RubyKafkaRetry

The `ruby_kafka_retry` gem provides a mechanism to handle message retries and dead-letter queue (DLQ) functionality in Ruby applications using Kafka. It ensures messages are retried with an increasing delay before being sent to a DLQ.

## Installation

Add this line to your application's Gemfile:

```ruby
source "https://rubygems.pkg.github.com/veeraveeraveera" do
  gem "ruby_kafka_retry", "0.1.0"
end
```

And then execute:

    $ bundle install

<!-- Or install it yourself as:

    $ gem install ruby_kafka_retry -->

## Usage
# Retrying Messages
To handle message retries, use the `RubyKafkaRetry::RetryFailedEvent` class. This class allows you to specify the retry topic, DLQ topic, and the message to be retried, along with an optional maximum retry attempt count.

```ruby
retry_topic = 'my_retry_topic'
dlq_topic = 'my_dlq_topic'
topic_message = { key: 'value' }  # The message to be processed
max_retry_attempt = 5  # Optional parameter, default is 3 if not provided

retry_event = RubyKafkaRetry::RetryFailedEvent.new(retry_topic, dlq_topic, topic_message, max_retry_attempt)
retry_event.retry
```

# Detailed Description
1. **First Retry Attempt**: If the topic_message does not include the `current_retry_attempt` key, the gem considers it as the first retry attempt and `current_retry_attempt` will be appended to the `topic_message` with the value as 1. The modified `topic_message` will then be published to the retry_topic.
2. **Message Format**: The `topic_message` must be a hash. If a non-hash object is passed, the gem will raise an error:
     ```ruby
     raise TypeError, 'topic_message must be a Hash'
     ```
3. **Retry Logic**:
    * If the `current_retry_attempt` value in the topic_message reaches the `max_retry_attempt` count, the message will be published to the DLQ topic.
    * If the `current_retry_attempt` value is less than the `max_retry_attempt`, the `current_retry_attempt` value will be incremented, and the message will be republished to the `retry_topic` after a delay.
    * The delay before republishing is calculated as `2 ** current_retry_attempt` minutes.
    * The `max_retry_attempt` parameter is optional. If it is not provided, the default value is `3`.

# Example Workflow
Here's a step-by-step example workflow:
1. A message `topic_message = { key: 'value' }` is received and processed.
2. If processing fails, it triggers a retry:
    * `current_retry_attempt` key is added to the message if not present.
    * Message becomes `{ key: 'value', current_retry_attempt: 1 }`.
3. The message is published to the `retry_topic` after a delay of 2 ** 1 (2 minutes).
4. If processing fails again, current_retry_attempt is incremented, and the message is republished after a delay of 2 ** 2 (4 minutes).
5. This continues until `current_retry_attempt` reaches `max_retry_attempt`.
6. Once `max_retry_attempt` is reached, the message is published to the DLQ topic.

# Configuration
You need to configure the gem by creating a YAML configuration file at `config/ruby_kafka_retry.yml`. This file should contain the following settings:

```ruby
development:
  client_id: "my_kafka_client_id"
  brokers:
    - "localhost:9092"
  ssl_ca_certs_from_system: false
  redis_host: "127.0.0.1"
  redis_db: "10"
  redis_port: "6379"

stage:
  client_id: "my_kafka_client_id"
  brokers:
    - "localhost:9092"
  ssl_ca_certs_from_system: false
  redis_host: "127.0.0.1"
  redis_db: "10"
  redis_port: "6379"

production:
  client_id: "my_kafka_client_id"
  brokers:
    - "localhost:9092"
  ssl_ca_certs_from_system: false
  redis_host: "127.0.0.1"
  redis_db: "10"
  redis_port: "6379"
```

# Dependencies
The `ruby_kafka_retry` gem depends on the following gems:
* ruby-kafka
* sidekiq

# Running Services
To use this gem, ensure the following services are running in the background:
1. **Kafka Server**: Ensure your Kafka server is up and running.
2. **Sidekiq Server**: Start your Sidekiq server to handle background job processing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/veeraveeraveera/ruby_kafka_retry.
