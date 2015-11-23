module Cloudat
  module Aws
    # Format Filters for AWS resources
    class Filters
      # Builds an array of aws-sdk ready filters from a hash of filters
      # @param options [Hash] Hash of filters to be turned into an array
      # @return [Array<Hash>] Array of name=values hashes
      def self.builder(options = {})
        filters = []
        options.each do |name, values|
          values = [values] unless values.is_a?(Array)
          filters << { name: name, values: values }
        end
        filters
      end
    end
  end
end
