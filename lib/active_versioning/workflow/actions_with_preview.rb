module ActiveVersioning
  module Workflow
    module ActionsWithPreview
      include ActiveVersioning::Workflow::PreviewLink

      def actions_with_preview
        actions defaults: false do |resource|
          item preview_link_for(resource, class: :member_link) if ActiveVersioning::Workflow.previewable?(resource)

          defaults(resource, css_class: :member_link)
        end
      end
    end
  end
end
