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
        resource_path = proc do |resource|
          param     = resource.try(:slug) || resource.to_param
          route_key = resource.model_name.singular_route_key

          options.fetch(:context, self).send("#{route_key}_path", param, _preview: true)
        end

        resource.try(:path, _preview: true) || resource_path.call(resource)
      end
    end
  end
end
