module Cloudat
  module Resource
    module Aws
      # Resource for an AWS EC2 instance
      class InstanceResource < Cloudat::Resource::BaseResource
        attr_accessor :subnet, :security_group

        # @see Cloudat::Resource::BaseResource.builder
        def self.builder(config, *options)
          if options.length > 0 && options.first.is_a?(Regexp)
            find_by_identifer(config, options.first)
          else
            find_by_filters(config, *options)
          end
        end

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

        private

        def self.find_by_identifer(config, regexp)
          instances = []
          res = ::Aws::EC2::Resource.new
          res.instances.each do |instance|
            instances << new(config, instance.id) if instance.id =~ regexp
          end
          instances
        end

        def self.find_by_filters(config, *options)
          filters = Cloudat::Aws::Filters.builder(options.first)
          options = { filters: filters } if options.length > 0
          instances = []
          res = ::Aws::EC2::Resource.new
          res.instances(options).each do |instance|
            instances << new(config, instance.id)
          end
          instances
        end
      end
    end
  end
end
