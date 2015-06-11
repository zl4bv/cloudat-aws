module Cloudat
  module Resource
    module Aws
      # Resource for an AWS Auto-scaling group
      class AutoScalingGroupResource < Cloudat::Resource::BaseResource
        # @return [Aws::AutoScaling::Group] Group object representing the
        #   auto-scaling group.
        def group
          @group ||= ::Aws::AutoScaling::Group.new(identifier)
        end

        # Suspends auto-scaling processes for the group. All processes are
        # suspended by default.
        # @return [Struct] Calls {Aws::AutoScaling::Group#suspend_processes},
        #   returning its response.
        def action_suspend
          response = group.suspend_processes
          logger.info("Auto-scaling group #{identifier} has suspended processes")
          response
        rescue ::Aws::AutoScaling::Errors::ServiceError => e
          logger.error("Failed to suspend processes for #{identifier}: #{e.message}")
        end

        # Resumes auto-scaling processes that were previously suspended. All
        # processes are resumed by default.
        # @return [Struct] Calls {Aws::AutoScaling::Group#resume_processes},
        #   returning its response.
        def action_resume
          response = group.resume_processes
          logger.info("Auto-scaling group #{identifier} has resumed processes")
          response
        rescue ::Aws::AutoScaling::Errors::ServiceError => e
          logger.error("Failed to suspend processes for #{identifier}: #{e.message}")
        end

        Resource.register(self)
      end
    end
  end
end
