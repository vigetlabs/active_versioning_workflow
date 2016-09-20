require 'active_versioning'
require 'active_versioning/workflow/engine'
require 'generators/active_versioning/workflow_generator'

module ActiveVersioning
  module Workflow
    autoload :ActionsWithPreview, 'active_versioning/workflow/actions_with_preview'
    autoload :Controller,         'active_versioning/workflow/controller'
    autoload :DraftActions,       'active_versioning/workflow/draft_actions'
    autoload :DSL,                'active_versioning/workflow/dsl'
    autoload :Previewable,        'active_versioning/workflow/previewable'
    autoload :PreviewLink,        'active_versioning/workflow/preview_link'
    autoload :Router,             'active_versioning/workflow/router'
    autoload :ShowResource,       'active_versioning/workflow/show_resource'
    autoload :ShowVersion,        'active_versioning/workflow/show_version'

    def self.previewable?(resource)
      preview_controller = "#{resource.class.to_s.pluralize}Controller".safe_constantize

      preview_controller.present? && preview_controller.singleton_class.ancestors.include?(Previewable)
    end
  end
end
