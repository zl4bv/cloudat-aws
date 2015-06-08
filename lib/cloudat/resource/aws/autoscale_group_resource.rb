module Cloudat
  module Resource
    module Aws
      # Resource for an AWS Auto-scaling group
      class AutoscaleGroupResource < Cloudat::Resource::BaseResource
        Resource.register(self, :suspend, :resume)

        attr_accessor :id

        def suspend
          puts "Auto-scale group #{@id} has been suspended"
        end

        def resume
          puts "Auto-scale group #{@id} has been resumed"
        end
      end
    end
  end
end
