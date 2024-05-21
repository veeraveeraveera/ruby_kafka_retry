# frozen_string_literal: true

require_relative "lib/ruby_kafka_retry/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_kafka_retry"
  spec.version = RubyKafkaRetry::VERSION
  spec.authors = ["veeramani.t"]
  spec.email = ["veeramani.t@caratlane.com"]

  spec.summary = "Kafka exponential delay retry"
  spec.description = "Kafka exponential delay retry"
  spec.homepage = "https://github.com/veeraveeraveera/ruby_kafka_retry"
  spec.required_ruby_version = ">= 2.2"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/veeraveeraveera"

  spec.metadata["homepage_uri"] = "https://github.com/veeraveeraveera/ruby_kafka_retry"
  spec.metadata["source_code_uri"] = "https://github.com/veeraveeraveera/ruby_kafka_retry"
  spec.metadata["changelog_uri"] = "https://github.com/veeraveeraveera/ruby_kafka_retry"

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "rails", ">= 4.2"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
