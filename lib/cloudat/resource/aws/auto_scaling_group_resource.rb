module Cloudat
  module Resource
    module Aws
      # Resource for an AWS Auto-scaling group
      class AutoScalingGroupResource < Cloudat::Resource::BaseResource
        Resource.register(self, :suspend, :resume)

        def group
          @group ||= ::Aws::AutoScaling::Group.new(identifier)
        end

        def suspend
          group.suspend_processes
        end

        def resume
          group.resume_processes
        end
      end
    end
  end
end
