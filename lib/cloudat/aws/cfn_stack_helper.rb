module Cloudat
  module Aws
    # Collection of functions to manipulate Cfn stacks
    class CfnStackHelper
      # List the {Aws::CloudFormation::Stack} properties that can be used
      # to uniquely identify a stack
      def unique_identifiers
        [:stack_id, :stack_name]
      end

      # Indicates if a the {options} uniquely identify a stack
      def unique_stack_id?(options)
        unique_identifiers.any? do |identifier|
          options.keys.include?(identifier) && options[identifier].is_a?(String)
        end
      end

      # Indicates if a stack matches the criteria
      def selected?(stack, options)
        options.all? do |pair|
          matches?(stack, pair.first, pair.last)
        end
      end

      # Checks if a property matches the expected state
      # Custom checks can be added by providing a check_{property name} method
      def matches?(stack, property_name, value)
        check_name = "check_#{property_name}"

        # Perform a custom check if available
        return send(check_name, value) if respond_to? check_name

        # Otherwise do a regexp matching
        stack.send(property_name).match(value).present?
      end
    end
  end
end
