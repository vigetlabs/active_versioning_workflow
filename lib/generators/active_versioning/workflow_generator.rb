require 'rails/generators'

module ActiveVersioning
  class WorkflowGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def install_active_versioning
      InstallGenerator.new.tap do |generator|
        generator.destination_root = destination_root
        generator.install_models
        generator.install_migrations
      end
    end

    def install_initializers
      copy_file 'initializers/active_versioning_workflow.rb', 'config/initializers/active_versioning_workflow.rb'
    end
  end
end
