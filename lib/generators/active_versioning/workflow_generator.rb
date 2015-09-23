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

    def install_router
      route 'self.class.send(:include, ActiveVersioning::Workflow::Router)'
    end

    def install_locales
      copy_file 'locales/active_versioning.en.yml', 'config/locales/active_versioning.en.yml'
    end

    def install_active_admin_resources
      copy_file 'active_admin_resources/version.rb', 'app/admin/version.rb'
    end

    def install_active_admin_views
      copy_file 'active_admin_views/_commit_form.html.erb', 'app/views/active_admin/resource/_commit_form.html.erb'
    end

    def install_assets
      copy_file 'stylesheets/active_versioning.scss', 'app/assets/stylesheets/active_versioning.scss'
      copy_file 'javascripts/active_versioning.js', 'app/assets/javascripts/active_versioning.js'
    end
  end
end
