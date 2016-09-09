module ActiveVersioning
  module Workflow
    module DraftActions
      def draft_actions
        if object.new_record?
          actions
        else
          actions do
            action :submit, label: t('active_versioning.actions.draft')
            cancel_link
          end
        end
      end
    end
  end
end
