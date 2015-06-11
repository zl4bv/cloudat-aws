module Cloudat
  module Resource
    module Aws
      # Resource for an AWS CloudFormation Stack
      class CfnStackResource < Cloudat::Resource::BaseResource
        attr_accessor :name

        def action_create
          puts "CloudFormation stack #{@name} created"
        end

        def action_destroy
          puts "CloudFormation stack #{@name} destroyed"
        end

        Resource.register(self)
      end
    end
  end
end
