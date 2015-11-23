require 'cloudat/aws/cfn_stack_helper'

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
          stack.delete
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
          stack_helper = options.fetch(:helper) { Cloudat::Aws::CfnStackHelper.new }

          # If a full stack id is provided, return it
          return find_stack(*options) if stack_helper.unique_stack_id?(options)

          # Unfortunately the AWS SDK doesn't provide filters, so we have to
          # iterate through all the stacks
          stacks = resource.stacks.select do |stack|
            stack_helper.selected?(stack, options)
          end

          [stacks].flatten
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
