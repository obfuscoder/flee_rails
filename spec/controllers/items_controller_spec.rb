require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe ItemsController do
  it_behaves_like "a standard controller" do
    let(:valid_update_attributes) { { description: "New Description" } }
    let(:invalid_update_attributes) { { description: nil } }
  end
end
