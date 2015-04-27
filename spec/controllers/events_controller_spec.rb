require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe EventsController do
  it_behaves_like 'a standard controller' do
    let(:valid_update_attributes) { { name: 'New Event' } }
    let(:invalid_update_attributes) { { name: nil } }
  end
end
