module Cloudat
  module Resource
    module Aws
      # Resource for an AWS EC2 instance
      class InstanceResource < Cloudat::Resource::BaseResource
        Resource.register(self, :start, :stop, :terminate)

        attr_accessor :id, :subnet, :security_group

        def initialize(config, *args)
          @id = args[0] if args.length == 1
          super(config, *args)
        end

        def start
          puts "Instance #{@id} has started"
        end

        def stop
          puts "Instance #{@id} has stopped"
        end

        def terminate
          puts "Instance #{@id} has terminated"
        end
      end
    end
  end
end
