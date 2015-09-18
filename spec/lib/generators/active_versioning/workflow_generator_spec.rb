require 'spec_helper'

RSpec.describe ActiveVersioning::WorkflowGenerator, type: :generator do
  destination File.expand_path('../../../../../tmp', __FILE__)

  before do
    prepare_destination
    run_generator
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
end
