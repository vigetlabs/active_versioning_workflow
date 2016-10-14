module ActiveVersioning
  module Workflow
    module PreviewLink
      def preview_link_for(resource, link_options={})
        link_to I18n.t('active_versioning.links.preview'), preview_path_for(resource), link_options.merge(
          class:  'preview-link',
          target: :blank
        )
      end

      def preview_path_for(resource, options = {})
        path = if resource.respond_to? :path
          resource.path(_preview: true)
        end

        path.presence || preview_path_proc.call(resource, options)
      end

      private

      def preview_path_proc
        proc do |resource, options|
          param     = resource.try(:slug) || resource.to_param
          route_key = resource.model_name.singular_route_key

          options.fetch(:context, self).send("#{route_key}_path", param, _preview: true)
        end
      end
    end
  end
end
