require 'active_versioning/workflow'

ActiveAdmin::ResourceDSL.send(:include, ActiveVersioning::Workflow::DSL)
ActiveAdmin::Views::ActiveAdminForm.send(:include, ActiveVersioning::Workflow::DraftActions)
ActiveAdmin::Views::IndexAsTable::IndexTableFor.send(:include, ActiveVersioning::Workflow::ActionsWithPreview)
