module ActiveVersioning
  module Workflow
    class ShowVersion < ::ActiveAdmin::Views::Pages::Show
      def main_content
        instance_exec(version, &show_block)
      end

      def version_attributes_panel(version, &block)
        panel(I18n.t('active_admin.details', model: resource_config.resource_label)) do
          instance_eval(&block)
        end
      end

      def version_details_panel
        panel(I18n.t('active_admin.details', model: Version.model_name.human)) do
          attributes_table_for(resource) do
            row 'Responsible for Change', &:committer
            row :commit_message
            row :committed_at
          end
        end
      end

      def versioned_resource
        @versioned_resource ||= resource.reify
      end


      private

      def show_block
        config.block || default_show_block
      end

      def default_show_block
        proc do
          instance_exec(versioned_resource, &version_block)

          version_details_panel
        end
      end

      def resource_config
        active_admin_namespace.resource_for(versioned_resource.class)
      end

      def version_block
        resource_config.get_page_presenter(:show_version).block
      end
    end
  end
end
