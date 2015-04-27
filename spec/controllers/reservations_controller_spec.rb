require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe ReservationsController do
  it_behaves_like 'a standard controller' do
    let(:valid_update_attributes) { { number: 42 } }
    let(:invalid_update_attributes) { { number: 0 } }
  end
end
