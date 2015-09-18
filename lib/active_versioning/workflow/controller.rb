module ActiveVersioning
  module Workflow
    module Controller
      def self.extended(base)
        base.cattr_reader :_previewable_resource_method

        base.include InstanceMethods
      end

      def preview_resource(resource_method)
        class_variable_set(:@@_previewable_resource_method, resource_method)

        before_action :use_draft_as_resource, only: :show, if: :previewing?
      end


      module InstanceMethods
        private

        def use_draft_as_resource
          instance_variable_set("@#{_previewable_resource_method}", find_resource.current_draft)
        end

        def previewing?
          params.has_key?(:_preview)
        end
      end
    end
  end
end
