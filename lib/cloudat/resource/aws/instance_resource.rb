module Cloudat
  module Resource
    module Aws
      # Resource for an AWS EC2 instance
      class InstanceResource < Cloudat::Resource::BaseResource
        attr_accessor :subnet, :security_group

        # @return [Aws::EC2::Instance] Instance object representing the
        #   EC2 instance
        def instance
          @instance ||= ::Aws::EC2::Instance.new(identifier)
        end

        # Starts the instance if was previously stopped. Only applicable to
        # Amazon EBS-backed instances.
        # @return [Struct] Calls {Aws::EC2::Instance#stop}, returning
        #   its response.
        def action_start
          response = instance.start
          logger.info("Instance #{identifier} has started")
          response
        rescue ::Aws::EC2::Errors::ServiceError => e
          logger.error("Failed to start instance #{identifier}: #{e.message}")
        end

        # Stops the instance. Only applicable to Amazon EBS-backed instances.
        # @return [Struct] Calls {Aws::EC2::Instance#stop}, returning
        #   its response.
        def action_stop
          response = instance.stop
          logger.info("Instance #{identifier} has stopped")
          response
        rescue ::Aws::EC2::Errors::ServiceError => e
          logger.error("Failed to start instance #{identifier}: #{e.message}")
        end

        # Shuts down the instance. The root device and any other devices
        # attached during the instance launch are automatically deleted.
        # @return [Struct] Calls {Aws::EC2::Instance#terminate}, returning
        #   its response.
        def action_terminate
          instance.terminate
          logger.info("Instance #{identifier} has terminated")
        rescue ::Aws::EC2::Errors::ServiceError => e
          logger.error("Failed to start instance #{identifier}: #{e.message}")
        end

        Resource.register(self)
      end
    end
  end
end
