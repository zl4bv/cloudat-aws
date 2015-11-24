require 'aws-sdk'

module Cloudat
  module Aws
    # rubocop: disable Metrics/MethodLength
    # Runs a block, and retries it with a sleep period if a Throttling exception
    # is raised
    def self.with_backoff(max_retries = 10,
                     exception = ::Aws::CloudFormation::Errors::Throttling,
                     base_value = 0.2,
                     multiplier = 2,
                     &block)
      sleep_period = 0
      begin
        block.call
        sleep(sleep_period)
      rescue exception => e
        # First try to reexucte the block with an increased sleep period
        sleep_period = base_value if sleep_period == 0
        sleep_period *= multiplier
        max_retries -= 1
        retry if max_retries > 0

        # Reraise the exception
        raise exception, "Too many attempts"
      end
    end
  end
end
