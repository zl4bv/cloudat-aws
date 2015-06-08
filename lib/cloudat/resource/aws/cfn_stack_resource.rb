module Cloudat
  module Resource
    module Aws
      # Resource for an AWS CloudFormation Stack
      class CfnStackResource < Cloudat::Resource::BaseResource
        Resource.register(self, :create, :destroy)

        attr_accessor :name

        def create
          puts "CloudFormation stack #{@name} created"
        end

        def destroy
          puts "CloudFormation stack #{@name} destroyed"
        end
      end
    end
  end
end
