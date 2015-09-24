module ActiveVersioning
  module Workflow
    class Engine < ::Rails::Engine
      isolate_namespace ActiveVersioning

      engine_name 'active_versioning_workflow'
    end
  end
end
