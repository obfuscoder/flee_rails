require 'rails_helper'
require 'support/shared_examples_for_controllers'

RSpec.describe SellersController do
  it_behaves_like "a standard controller" do
    let(:valid_update_attributes) { { first_name: "Newfirst", last_name: "Newlast" } }
    let(:virtual_attributes) { { accept_terms: "1" } }
    let(:invalid_update_attributes) { { first_name: nil, last_name: nil } }
  end
end
