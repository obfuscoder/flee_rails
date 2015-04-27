require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe CategoriesController do
  it_behaves_like 'a standard controller' do
    let(:valid_update_attributes) { { name: 'New Category' } }
    let(:invalid_update_attributes) { { name: nil } }
  end
end
