require 'active_versioning'
require 'generators/active_versioning/workflow_generator'

module ActiveVersioning
  module Workflow
    autoload :Controller,   'active_versioning/workflow/controller'
    autoload :DraftActions, 'active_versioning/workflow/draft_actions'
    autoload :DSL,          'active_versioning/workflow/dsl'
    autoload :Previewable,  'active_versioning/workflow/previewable'
    autoload :Router,       'active_versioning/workflow/router'
    autoload :ShowResource, 'active_versioning/workflow/show_resource'
    autoload :ShowVersion,  'active_versioning/workflow/show_version'
  end
end
