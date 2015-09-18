require 'spec_helper'

RSpec.describe ActiveVersioning::Workflow do
  it "has a version number" do
    expect(ActiveVersioning::Workflow::VERSION).not_to be nil
  end
end
