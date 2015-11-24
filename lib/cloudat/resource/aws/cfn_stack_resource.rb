require 'active_support/core_ext/object/blank.rb'
require 'aws-sdk'

module Cloudat
  module Resource
    module Aws
      # Resource for an AWS CloudFormation Stack
      class CfnStackResource < Cloudat::Resource::BaseResource
        attr_accessor :name

        # @see Cloudat::Resource::BaseResource.builder
        def self.builder(config, *options)
          stacks = find_cfn_stacks(config, *options)
          stacks.map do |stack|
            CfnStackResource.from_stack_id(config, stack.stack_id)
          end
        end

        def action_create
          fail NotImplementedError
        end

        def action_destroy
          puts "Destroying Clouformation stacks #{identifier}"
          stack = CfnStackResource.resource.stack(identifier)
          fail ArgumentError, "Error fetching stack #{identifier}" unless stack
          #stack.delete
        end

        Resource.register(self)

        def self.resource
          ::Aws::CloudFormation::Resource.new
        end

        def self.from_stack_id(config, stack_id)
          new(config, stack_id)
        end

        # Find stacks by their name, id and more
        # @param config [Cloudat::Configuration] Application configuration
        # @option options [RegExp|String] @see #find
        # @option options [RegExp] :matching Find stacks matching a RegExp
        # @return [Array<Cloudat::Resource::CfnStackResource] List of cfn stacks
        #    that match the array
        def self.find_cfn_stacks(_config, options)
          # If a full stack id is provided, return it
          return find_stack(*options) if unique_stack_id?(options)

          # Unfortunately the AWS SDK doesn't provide filters, so we have to
          # iterate through all the stacks
          stacks = resource.stacks.select do |stack|
            selected?(stack, options)
          end

          [stacks].flatten
        end

        # List the {Aws::CloudFormation::Stack} properties that can be used
        # to uniquely identify a stack
        def self.unique_identifiers
          [:stack_id, :stack_name]
        end

        # Indicates if a the {options} uniquely identify a stack
        def self.unique_stack_id?(options)
          unique_identifiers.any? do |identifier|
            options.keys.include?(identifier) && options[identifier].is_a?(String)
          end
        end

        # Indicates if a stack matches the criteria
        def self.selected?(stack, options)
          options.all? do |pair|
            matches?(stack, pair.first, pair.last)
          end
        end

        # Checks if a property matches the expected state
        # Custom checks can be added by providing a check_{property name} method
        def self.matches?(stack, property_name, value)
          check_name = "check_#{property_name}"

          # Perform a custom check if available
          return send(check_name, value) if respond_to? check_name

          # Otherwise do a regexp matching
          stack.send(property_name).match(value).present?
        end

        # Find a single stack by its name or id
        # @option options [RegExp|String] :stack_name Name of the stack
        # @option options [RegExp|String] :stack_id ID (Arn) of the stack
        # @return [Aws::CloudFormation::Stack] Cfn Stack object
        # :nocov: because it's just a call to the aws sdk
        def self.find_stack(*options)
          [resource.stack(*options)]
        end
        # :nocov:
      end
    end
  end
end
