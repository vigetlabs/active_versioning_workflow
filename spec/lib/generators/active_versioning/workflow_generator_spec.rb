require 'spec_helper'

RSpec.describe ActiveVersioning::WorkflowGenerator, type: :generator do
  TEST_DESTINATION_PATH = '../../../../../tmp'

  destination File.expand_path(TEST_DESTINATION_PATH, __FILE__)

  before do
    prepare_destination
    create_placeholder_routes_file
    run_generator
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  it "generates the version model" do
    assert_file 'app/models/version.rb', /class Version < ActiveRecord::Base/
  end

  it "generates the versions migration" do
    assert_migration 'db/migrate/*_create_versions.rb', /class CreateVersions < ActiveRecord::Migration/
  end

  it "generates the initializer" do
    assert_file 'config/initializers/active_versioning_workflow.rb', /ActiveVersioning::Workflow::DSL/
    assert_file 'config/initializers/active_versioning_workflow.rb', /ActiveVersioning::Workflow::DraftActions/
  end

  it "configures the routes file" do
    assert_file 'config/routes.rb', /self.class.send\(:include, ActiveVersioning::Workflow::Router\)/
  end

  it "generates the locales file" do
    assert_file 'config/locales/active_versioning.en.yml', /en:\s+active_versioning:/
  end

  it "generates the ActiveAdmin Version resource" do
    assert_file 'app/admin/version.rb', /ActiveAdmin.register Version/
  end

  it "generates the ActiveAdmin views" do
    assert_file 'app/views/active_admin/resource/_commit_form.html.erb', /form_tag \[:commit, :admin, resource\]/
  end

  def create_placeholder_routes_file
    (destination_root + '/config').tap do |folder|
      FileUtils.mkdir_p(folder)

      File.open(folder + '/routes.rb', 'w') do |file|
        file.write("Rails.application.routes.draw do\nend")
      end
    end
  end
end
